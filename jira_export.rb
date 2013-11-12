require 'csv'
require 'optparse'

options = {}
opt_parser = OptionParser.new do |opts|
  opts.banner = "Usage: jira_export.rb [options]"

  opts.on('-s', '--server_url server_url', 'Server URL') { |v| options[:server_url] = v }
  opts.on('-u', '--user user', 'User Name') { |v| options[:user] = v }
  opts.on('-p', '--password password', 'Password') { |v| options[:password] = v }
  opts.on('-f', '--filter filterid', 'Filter Id to be used for export') { |v| options[:filterid] = v }

end

opt_parser.parse(ARGV)

if (options.length == 0)
	puts opt_parser.help
	exit -1
end

output =  ""
server_url = options[:server_url]
user = options[:user]
password = options[:password]
filter_id = options[:filterid]
issues = `jira.sh --action getIssueList -s #{server_url} -u #{user} -p #{password} --filter #{filter_id} --outputFormat 998`
puts issues
exit 0
i_skiplines = 2
issue_list = []
issue_comment_list = []
issue_attachment_list = []
max_comment_count = 0
max_attachment_count = 0
header_row = ""
CSV.foreach("issue.csv") do |main_row|
	next if main_row.first.nil?
	if ( i_skiplines != 0 )
		if (i_skiplines == 1)
			header_row = main_row.to_csv()
			length = header_row.length-2
			header_row = header_row[0..length]
		end
		i_skiplines -= 1
		next
	end
	jira=main_row[0]

	str = main_row.to_csv()
	length = str.length-2
	str = str[0..length]
	issue_list.push(str);

	comment_list = []
	comment = `jira.sh --action getCommentList -s #{server_url} -u #{user} -p #{password} --issue #{jira} --outputFormat 999 > comments.csv`
	skiplines = 2
	CSV.foreach("comments.csv") do |row|
		next if row.first.nil?
		if ( skiplines != 0 )
			skiplines -= 1
			next
		end
		line = "" + row[3] + ";" + row[2]+";"+ (row[7].gsub("\"", "\"\""))
		comment_list.push(line)
	end
	max_comment_count = comment_list.length if (max_comment_count < comment_list.length)
	issue_comment_list.push(comment_list)

	attachment_list = []
#	attch = `jira.sh --action getAttachmentList -s #{server_url} -u #{user} -p #{password} --issue #{jira} >attachments.csv`
#	skiplines = 2
#	CSV.foreach("attachments.csv") do |row|
#		next if row.first.nil?
#		if ( skiplines != 0 )
#			skiplines -= 1
#			next
#		end
#		line = "#{server_url}secure/attachment/" + row[0] + "/" + row[1]
#		attachment_list.push(line)
#	end
	max_attachment_count = attachment_list.length if (max_attachment_count < attachment_list.length)
	issue_attachment_list.push(attachment_list)
end
for i in 0..(max_comment_count-1)
	header_row =  header_row + ",Comment"
end

for i in 0..(max_attachment_count-1)
	header_row += ",Attachment"
end
puts header_row
for i in 0..(issue_list.length-1)
	output = issue_list[i]
	output += ","
	str = issue_comment_list[i].to_csv()
	length = str.length-2
	str = str[0..length]
	output += str
	
	for j in (issue_comment_list[i].length)..max_comment_count
		output += ","
	end
	
	str = issue_attachment_list[i].to_csv()
	length = str.length-2
	str = str[0..length]
	output += str
	
	for j in (issue_attachment_list[i].length)..max_attachment_count
		output += ","
	end
	puts (output.gsub('\n',''))
end
