require 'formula'

class Elasticsearch < Formula
  homepage 'http://www.elasticsearch.org'
  url 'http://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-0.20.5.tar.gz'
  sha1 'e52cd5e7cae2be85d7df65315ec7b91e2e84f83e'
  version '0.20.5-boxen1'

  def cluster_name
    "elasticsearch_#{ENV['USER']}"
  end

  def install
    # Remove Windows files
    rm_f Dir["bin/*.bat"]
    # Move JARs from lib to libexec according to homebrew conventions
    libexec.install Dir['lib/*.jar']
    (libexec+'sigar').install Dir['lib/sigar/*.jar']

    # Install everything directly into folder
    prefix.install Dir['*']

    inreplace "#{bin}/elasticsearch.in.sh" do |s|
      # Replace CLASSPATH paths to use libexec instead of lib
      s.gsub! /ES_HOME\/lib\//, "ES_HOME/libexec/"
    end

    inreplace "#{bin}/elasticsearch" do |s|
      # Set ES_HOME to prefix value
      s.gsub! /^ES_HOME=.*$/, "ES_HOME=#{prefix}"
    end

    inreplace "#{bin}/plugin" do |s|
      # Set ES_HOME to prefix value
      s.gsub! /^ES_HOME=.*$/, "ES_HOME=#{prefix}"
      # Replace CLASSPATH paths to use libexec instead of lib
      s.gsub! /-cp \".*\"/, '-cp "$ES_HOME/libexec/*"'
    end
  end
end
