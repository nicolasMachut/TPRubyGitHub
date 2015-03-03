require 'open-uri'
require 'zlib'
require 'yajl'
require 'mongo'
require 'pp'

c = Mongo::Connection.new['githubArchive']

=begin
gz = open('http://data.githubarchive.org/2015-01-01-12.json.gz')
js = Zlib::GzipReader.new(gz).read

(0...23).each do |hour|
  puts hour
  gz = open(URI.encode("http://data.githubarchive.org/2015-01-13-#{hour}.json.gz"))
  js = Zlib::GzipReader.new(gz).read

  Yajl::Parser.parse(js) do |event|

    event['created_at'] = Time.parse(event['created_at'])
    c['events'] << event

  end
end
=end

 pp c['events'].aggregate([
                          {:$group=>{
                              :_id=>{
                                  hour: {:$hour=>"$created_at"},
                                  type: "$type"
                              },
                              :count=>{:$sum =>1}
                          }}
                      ])

