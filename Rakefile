# frozen_string_literal: true

require 'logger'
require 'nokogiri'
require 'pry'
require 'securerandom'

namespace :pulfa do
  desc "Retrieve the PULFA finding aid EAD Documents Subversion"
  task :checkout do
    check_if_lpass_installed
    check_if_logged_in

    lastpass_pulfa_svn_username = "Shared-ITIMS-Passwords/pulfa_svn_username"
    lastpass_pulfa_svn_password = "Shared-ITIMS-Passwords/pulfa_svn_password"
    lastpass_pulfa_svn_url = "Shared-ITIMS-Passwords/pulfa_svn_url"

    username = `lpass show --notes #{lastpass_pulfa_svn_username}`
    username.chomp!
    password = `lpass show --notes #{lastpass_pulfa_svn_password}`
    password.chomp!
    svn_url = `lpass show --notes #{lastpass_pulfa_svn_url}`
    svn_url.chomp!

    cmd = "/usr/bin/env svn checkout #{svn_url} eads/pulfa/ --username #{username} --non-interactive --password #{password}"

    exit_code = system(cmd)
    exit(exit_code)
  end

  desc "Clean the EAD Documents"
  task :clean do

    Dir.glob("eads/pulfa/**/*xml").each do |file_path|
      logger.info("Cleaning #{file_path}")

      file_content = File.read(file_path)

      cleaned_file_path = file_path.gsub(/\.EAD\.xml$/, '.cleaned.xml')

        doc = Nokogiri::XML(file_content)
        primary_dsc_elements = doc.xpath('/ead:ead/ead:archdesc/ead:dsc[@type!="othertype"]', 'ead' => 'urn:isbn:1-931666-22-9')
        primary_dsc_elements.each do |dsc|
          containers = dsc.xpath('ead:c', 'ead' => 'urn:isbn:1-931666-22-9')

          containers.each do |component|
            clean_component(component)
          end
        end

        # Remove the dsc2
        dsc2_elements = doc.xpath('/ead:ead/ead:archdesc/ead:dsc[@type="othertype"]', 'ead' => 'urn:isbn:1-931666-22-9')

        dsc2_elements.each do |dsc2|
          dsc2.remove
        end

      File.open(cleaned_file_path, 'wb') do |f|
        f << doc.to_xml
      end

      logger.info("Saved the cleaned EAD to #{cleaned_file_path}")
    end
  end

  # Utility methods

  def logger
    default_logger = Logger.new(STDOUT)
    default_logger.level = Logger::INFO
    default_logger
  end

  def clean_component(component)
    containers = component.xpath('ead:did/ead:container', 'ead' => 'urn:isbn:1-931666-22-9')

    containers.each do |container|
      container.delete('parent')
    end

    child_components = component.xpath('ead:c', 'ead' => 'urn:isbn:1-931666-22-9')
    child_components.each do |child|
      clean_component(child)
    end
  end

  # Determine if the lpass binary is installed and in the $PATH
  # @return [Boolean]
  def check_if_lpass_installed
    abort("You don't have the 'lpass' command tool") if `which lpass`.empty?
  end

  # Determine if the system user has authenticated using lpass
  # @return [Boolean]
  def check_if_logged_in
    abort("You must login first with: lpass login <login@name.com>") if system("lpass status -q") == false
  end
end
