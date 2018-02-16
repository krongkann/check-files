_       = require 'lodash'
fs      = require 'fs'
moment  = require 'moment'
csv     = require "fast-csv" 
momentIterator  = require 'moment-iterator'
path = require 'path'
console.log "Hello World"
holidayCSV     = __dirname+ '/holidays.csv'
pathFolder = __dirname + "/backup/archived/trinity/"

start =  moment("20160704")
end = moment("20180214")



dateRangeFromCSV = ( holidayCSV)->
  ret = []
  new Promise (resolve)->
    # return resolve []
    csv
      .fromPath(holidayCSV)
      .transform (data) ->
        moment(data[7]).format("YYYYMMDD")
      .on "data",(data)->
        ret.push data
      .on "end", () ->
        resolve ret

dateRange = (dateFrom, dateTo) ->
  ret =[]
  momentIterator(dateFrom, dateTo).each 'days', (d) ->
    if d.format('e') != '0' && d.format('e') != '6'
      ret.push d.format("YYYYMMDD")
  ret
  
walkSync = (dir, filelist) ->
  fs = fs || require('fs')
  files = fs.readdirSync(dir)
  filelist = filelist || []
  files.forEach (file) -> 
    if (fs.statSync(dir + file).isDirectory()) 
      filelist = walkSync(dir + file + '/', filelist)
    else 
      filelist.push(path.join dir, file)
    
  return filelist

main =() ->
  holidays = await dateRangeFromCSV holidayCSV
  dates = dateRange start, end
  count = 0
  workingDates = _.filter  dates, (d) ->
    !(d in holidays)
  files =   walkSync(pathFolder)
  for date in workingDates
    a =  _.find files, (file) ->
      ("aboss_022_dayended_#{date}.db" == path.basename(file) ) 
    b = _.find files, (file) ->
      ("input_#{date}.tgz" == path.basename(file) ) 
    c = _.find files, (file) ->
      ("output_#{date}.tgz" == path.basename(file) ) 
    if a && b && c 
      # console.log "date:#{date}  found" 
    else
      count += 1
      console.log "date:#{date} not found" 
      console.log "data base:", a unless (if a then true else false)
      console.log "input: ", b unless (if b then true else false)
      console.log "output: ", c unless (if c then true else false)
      console.log "============="
  console.log "not found ", count
main()
