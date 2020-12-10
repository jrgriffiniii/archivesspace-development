require 'archivesspace/client'
require 'csv'
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

accessions_for_repo = 'repositories/'+repo+'/accessions'

#get all ids
accession_ids = client.get(accessions_for_repo, {
  query: {
   all_ids: true
  }}).parsed

  #get a count of ids
  count_accession_ids = accession_ids.count

#for each id, get the accession record and add to array of accession records
results = []
count_processed_records = 0
while count_processed_records < count_accession_ids do
  last_record = [count_processed_records+249, count_accession_ids].min
  results << client.get(accessions_for_repo, {
          query: {
            id_set: accession_ids[count_processed_records..last_record]
          }
        })
  count_processed_records = last_record
  end

#iterate over accession record and write selected fields to csv
filename = "repo"+repo+".csv"
CSV.open(filename, "wb",
    :write_headers=> true,
    :headers => ["uri", "id_0.id_1.id_2", "string_2", "disposition", "processing_plan", "related_resources"]) do |row|

  results.each do |result|
    result.parsed.each do |record|
      uri =
        unless record['uri'].nil?
          then record['uri']
        else ' '
        end
      related_resources = []
            record['related_resources'].each do |resource|
              resource.each do |key, value|
                related_resources << value
              end
            end
      related_resources = related_resources.join(', ')
      callno =
        unless record['user_defined'].nil?
          then
            unless record['user_defined']['string_2'].nil?
            then record['user_defined']['string_2']
            else ' '
            end
        else ' '
        end
      processing_plan =
       unless record['collection_management'].nil?
         then
          unless record['collection_management']['processing_plan'].nil?
          then record['collection_management']['processing_plan']
          else ' '
          end
        else ' '
        end
      disposition = record['disposition']
      accession_id =
        unless record['id_0'].nil?
          then record['id_0'] +
          unless record['id_1'].nil? then "." + record['id_1'] else ' ' end +
          unless record['id_2'].nil? then "." + record['id_2'] else ' ' end
        else ' '
        end
      row << [uri, accession_id, callno, disposition, processing_plan, related_resources]
        end
  end
end
