# encoding: UTF-8

require 'spec_helper'

describe Gjp::JarTable do
  let(:dir) { File.join("spec", "data", "ant-super-simple-code") }
  let(:jar_table) { Gjp::JarTable.new(dir, true) }

  describe "#get_jars" do
    it "finds jar paths in a directory" do 
      jar_table.get_jars(dir).should include(
        File.join(dir, "dist", "antsimple-20130618.jar"),
        File.join(dir, "lib", "junit-4.11.jar"),
        File.join(dir, "lib", "log4j-1.2.13.jar")
      )
    end
  end

  describe "#get_jar_defined_packages" do
    it "finds the package names part of a jar file" do 
      jar_table.get_jar_defined_packages(File.join(dir, "lib", "junit-4.11.jar")).should include(
        "junit.framework",
        "junit.extensions",
        "org.junit.runner",
        "org.junit.runners.model"
      )
    end
  end

  describe "#sources" do
    it "finds source paths in a directory" do 
      jar_table.get_sources(dir).should include(
        File.join(dir, "src", "mypackage", "HW.java")
      )
    end
  end

  describe "#source_defined_packages" do
    it "finds the package names built from this project" do 
      jar_table.source_defined_packages.should include("mypackage")
    end
  end

  describe "#runtime_required_packages" do
    it "finds the package names required by this project's sources" do 
      jar_table.runtime_required_packages.should include("org.apache.log4j")
    end
  end

  describe "#rows" do
    it "returns jar data" do
      jar_table.rows.should include(
        "spec/data/ant-super-simple-code/lib/log4j-1.2.13.jar" => :required,
        "spec/data/ant-super-simple-code/lib/junit-4.11.jar" => :build_required,
        "spec/data/ant-super-simple-code/dist/antsimple-20130618.jar" => :produced
      )
    end
  end
end