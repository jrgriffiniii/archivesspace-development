require 'archivesspace/client'
require_relative 'sandbox_auth'

#configure access
config = ArchivesSpace::Configuration.new({
  base_uri: "https://aspace.princeton.edu/staff/api",
  base_repo: "",
  username: @user,
  password: @password,
  #page_size: 50,
  throttle: 0,
  verify_ssl: false,
})

#log in
client = ArchivesSpace::Client.new(config).login

#get repo number
puts "What repo? Type 5 for mss, 4 for ua, 3 for ppp."
repo = gets.chomp

#get all ids
container_ids = client.get('/repositories/' + repo + '/top_containers',{
  query: {
   all_ids: true
  }}).parsed

#puts container_ids

#get a count of ids
count_ids = container_ids.count

pages = []

count_processed_records = 0
while count_processed_records < count_ids do
  last_record = [count_processed_records+249, count_ids].min
  pages << client.get('/repositories/' + repo + '/top_containers', {
              query: {
                id_set: container_ids[count_processed_records..last_record]
              }})
  count_processed_records = last_record
end

#get containers with their locations, if any
pages.each do |page|
  page.parsed.each do |record|
    uri = record['uri']
    #locations = []
      unless record['container_locations'].empty?
        then record['container_locations'].each do |location|
        #locations << location['ref']
          puts uri + ' : ' + location['ref']
        end
      else puts uri + ' : '
      end
  end
end
