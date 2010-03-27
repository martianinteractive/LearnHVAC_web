# DO NOT MODIFY THIS FILE

require 'digest/sha1'
require 'rubygems'

module Gem
  class Dependency
    if !instance_methods.map { |m| m.to_s }.include?("requirement")
      def requirement
        version_requirements
      end
    end
  end
end

module Bundler
  module SharedHelpers

    def default_gemfile
      gemfile = find_gemfile
      gemfile or raise GemfileNotFound, "The default Gemfile was not found"
      Pathname.new(gemfile)
    end

    def in_bundle?
      find_gemfile
    end

  private

    def find_gemfile
      return ENV['BUNDLE_GEMFILE'] if ENV['BUNDLE_GEMFILE']

      previous = nil
      current  = File.expand_path(Dir.pwd)

      until !File.directory?(current) || current == previous
        filename = File.join(current, 'Gemfile')
        return filename if File.file?(filename)
        current, previous = File.expand_path("..", current), current
      end
    end

    def clean_load_path
      # handle 1.9 where system gems are always on the load path
      if defined?(::Gem)
        me = File.expand_path("../../", __FILE__)
        $LOAD_PATH.reject! do |p|
          next if File.expand_path(p).include?(me)
          p != File.dirname(__FILE__) &&
            Gem.path.any? { |gp| p.include?(gp) }
        end
        $LOAD_PATH.uniq!
      end
    end

    def reverse_rubygems_kernel_mixin
      # Disable rubygems' gem activation system
      ::Kernel.class_eval do
        if private_method_defined?(:gem_original_require)
          alias rubygems_require require
          alias require gem_original_require
        end

        undef gem
      end
    end

    def cripple_rubygems(specs)
      reverse_rubygems_kernel_mixin

      executables = specs.map { |s| s.executables }.flatten

     :: Kernel.class_eval do
        private
        def gem(*) ; end
      end
      Gem.source_index # ensure RubyGems is fully loaded

      ::Kernel.send(:define_method, :gem) do |dep, *reqs|
        if executables.include? File.basename(caller.first.split(':').first)
          return
        end
        opts = reqs.last.is_a?(Hash) ? reqs.pop : {}

        unless dep.respond_to?(:name) && dep.respond_to?(:requirement)
          dep = Gem::Dependency.new(dep, reqs)
        end

        spec = specs.find  { |s| s.name == dep.name }

        if spec.nil?
          e = Gem::LoadError.new "#{dep.name} is not part of the bundle. Add it to Gemfile."
          e.name = dep.name
          e.version_requirement = dep.requirement
          raise e
        elsif dep !~ spec
          e = Gem::LoadError.new "can't activate #{dep}, already activated #{spec.full_name}. " \
                                 "Make sure all dependencies are added to Gemfile."
          e.name = dep.name
          e.version_requirement = dep.requirement
          raise e
        end

        true
      end

      # === Following hacks are to improve on the generated bin wrappers ===

      # Yeah, talk about a hack
      source_index_class = (class << Gem::SourceIndex ; self ; end)
      source_index_class.send(:define_method, :from_gems_in) do |*args|
        source_index = Gem::SourceIndex.new
        source_index.spec_dirs = *args
        source_index.add_specs(*specs)
        source_index
      end

      # OMG more hacks
      gem_class = (class << Gem ; self ; end)
      gem_class.send(:define_method, :bin_path) do |name, *args|
        exec_name, *reqs = args

        spec = nil

        if exec_name
          spec = specs.find { |s| s.executables.include?(exec_name) }
          spec or raise Gem::Exception, "can't find executable #{exec_name}"
        else
          spec = specs.find  { |s| s.name == name }
          exec_name = spec.default_executable or raise Gem::Exception, "no default executable for #{spec.full_name}"
        end

        gem_bin = File.join(spec.full_gem_path, spec.bindir, exec_name)
        gem_from_path_bin = File.join(File.dirname(spec.loaded_from), spec.bindir, exec_name)
        File.exist?(gem_bin) ? gem_bin : gem_from_path_bin
      end
    end

    extend self
  end
end

module Bundler
  LOCKED_BY    = '0.9.13'
  FINGERPRINT  = "96274e2c7ad19c0bd9e78b4ab78f111fc11b9102"
  AUTOREQUIRES = {:test=>[["factory_girl", false], ["mocha", false], ["rspec-rails", false]], :default=>[["haml", false], ["compass", false], ["mongo", false], ["mongo_ext", false], ["will_paginate", false], ["mongoid", false], ["mysql", false], ["rails", false]], :development=>[["hirb", false], ["ruby-debug", false]]}
  SPECS        = [
        {:loaded_from=>"/Users/sergiobayona/.rvm/gems/ruby-1.8.7-p72/specifications/rake-0.8.7.gemspec", :load_paths=>["/Users/sergiobayona/.rvm/gems/ruby-1.8.7-p72/gems/rake-0.8.7/lib"], :name=>"rake"},
        {:loaded_from=>"/Users/sergiobayona/.rvm/gems/ruby-1.8.7-p72/specifications/abstract-1.0.0.gemspec", :load_paths=>["/Users/sergiobayona/.rvm/gems/ruby-1.8.7-p72/gems/abstract-1.0.0/lib"], :name=>"abstract"},
        {:loaded_from=>"/Users/sergiobayona/.rvm/gems/ruby-1.8.7-p72/specifications/builder-2.1.2.gemspec", :load_paths=>["/Users/sergiobayona/.rvm/gems/ruby-1.8.7-p72/gems/builder-2.1.2/lib"], :name=>"builder"},
        {:loaded_from=>"/Users/sergiobayona/.rvm/gems/ruby-1.8.7-p72/specifications/i18n-0.3.6.gemspec", :load_paths=>["/Users/sergiobayona/.rvm/gems/ruby-1.8.7-p72/gems/i18n-0.3.6/lib"], :name=>"i18n"},
        {:loaded_from=>"/Users/sergiobayona/.rvm/gems/ruby-1.8.7-p72/specifications/memcache-client-1.7.8.gemspec", :load_paths=>["/Users/sergiobayona/.rvm/gems/ruby-1.8.7-p72/gems/memcache-client-1.7.8/lib"], :name=>"memcache-client"},
        {:loaded_from=>"/Users/sergiobayona/.rvm/gems/ruby-1.8.7-p72/specifications/tzinfo-0.3.17.gemspec", :load_paths=>["/Users/sergiobayona/.rvm/gems/ruby-1.8.7-p72/gems/tzinfo-0.3.17/lib"], :name=>"tzinfo"},
        {:loaded_from=>"/Users/sergiobayona/.rvm/gems/ruby-1.8.7-p72/specifications/activesupport-3.0.0.beta.gemspec", :load_paths=>["/Users/sergiobayona/.rvm/gems/ruby-1.8.7-p72/gems/activesupport-3.0.0.beta/lib"], :name=>"activesupport"},
        {:loaded_from=>"/Users/sergiobayona/.rvm/gems/ruby-1.8.7-p72/specifications/activemodel-3.0.0.beta.gemspec", :load_paths=>["/Users/sergiobayona/.rvm/gems/ruby-1.8.7-p72/gems/activemodel-3.0.0.beta/lib"], :name=>"activemodel"},
        {:loaded_from=>"/Users/sergiobayona/.rvm/gems/ruby-1.8.7-p72/specifications/erubis-2.6.5.gemspec", :load_paths=>["/Users/sergiobayona/.rvm/gems/ruby-1.8.7-p72/gems/erubis-2.6.5/lib"], :name=>"erubis"},
        {:loaded_from=>"/Users/sergiobayona/.rvm/gems/ruby-1.8.7-p72/specifications/rack-1.1.0.gemspec", :load_paths=>["/Users/sergiobayona/.rvm/gems/ruby-1.8.7-p72/gems/rack-1.1.0/lib"], :name=>"rack"},
        {:loaded_from=>"/Users/sergiobayona/.rvm/gems/ruby-1.8.7-p72/specifications/rack-mount-0.4.7.gemspec", :load_paths=>["/Users/sergiobayona/.rvm/gems/ruby-1.8.7-p72/gems/rack-mount-0.4.7/lib"], :name=>"rack-mount"},
        {:loaded_from=>"/Users/sergiobayona/.rvm/gems/ruby-1.8.7-p72/specifications/rack-test-0.5.3.gemspec", :load_paths=>["/Users/sergiobayona/.rvm/gems/ruby-1.8.7-p72/gems/rack-test-0.5.3/lib"], :name=>"rack-test"},
        {:loaded_from=>"/Users/sergiobayona/.rvm/gems/ruby-1.8.7-p72/specifications/actionpack-3.0.0.beta.gemspec", :load_paths=>["/Users/sergiobayona/.rvm/gems/ruby-1.8.7-p72/gems/actionpack-3.0.0.beta/lib"], :name=>"actionpack"},
        {:loaded_from=>"/Users/sergiobayona/.rvm/gems/ruby-1.8.7-p72/specifications/mime-types-1.16.gemspec", :load_paths=>["/Users/sergiobayona/.rvm/gems/ruby-1.8.7-p72/gems/mime-types-1.16/lib"], :name=>"mime-types"},
        {:loaded_from=>"/Users/sergiobayona/.rvm/gems/ruby-1.8.7-p72/specifications/mail-2.1.3.gemspec", :load_paths=>["/Users/sergiobayona/.rvm/gems/ruby-1.8.7-p72/gems/mail-2.1.3/lib"], :name=>"mail"},
        {:loaded_from=>"/Users/sergiobayona/.rvm/gems/ruby-1.8.7-p72/specifications/text-hyphen-1.0.0.gemspec", :load_paths=>["/Users/sergiobayona/.rvm/gems/ruby-1.8.7-p72/gems/text-hyphen-1.0.0/lib"], :name=>"text-hyphen"},
        {:loaded_from=>"/Users/sergiobayona/.rvm/gems/ruby-1.8.7-p72/specifications/text-format-1.0.0.gemspec", :load_paths=>["/Users/sergiobayona/.rvm/gems/ruby-1.8.7-p72/gems/text-format-1.0.0/lib"], :name=>"text-format"},
        {:loaded_from=>"/Users/sergiobayona/.rvm/gems/ruby-1.8.7-p72/specifications/actionmailer-3.0.0.beta.gemspec", :load_paths=>["/Users/sergiobayona/.rvm/gems/ruby-1.8.7-p72/gems/actionmailer-3.0.0.beta/lib"], :name=>"actionmailer"},
        {:loaded_from=>"/Users/sergiobayona/.rvm/gems/ruby-1.8.7-p72/specifications/arel-0.2.1.gemspec", :load_paths=>["/Users/sergiobayona/.rvm/gems/ruby-1.8.7-p72/gems/arel-0.2.1/lib"], :name=>"arel"},
        {:loaded_from=>"/Users/sergiobayona/.rvm/gems/ruby-1.8.7-p72/specifications/activerecord-3.0.0.beta.gemspec", :load_paths=>["/Users/sergiobayona/.rvm/gems/ruby-1.8.7-p72/gems/activerecord-3.0.0.beta/lib"], :name=>"activerecord"},
        {:loaded_from=>"/Users/sergiobayona/.rvm/gems/ruby-1.8.7-p72/specifications/activeresource-3.0.0.beta.gemspec", :load_paths=>["/Users/sergiobayona/.rvm/gems/ruby-1.8.7-p72/gems/activeresource-3.0.0.beta/lib"], :name=>"activeresource"},
        {:loaded_from=>"/Users/sergiobayona/.rvm/gems/ruby-1.8.7-p72/specifications/bundler-0.9.13.gemspec", :load_paths=>["/Users/sergiobayona/.rvm/gems/ruby-1.8.7-p72/gems/bundler-0.9.13/lib"], :name=>"bundler"},
        {:loaded_from=>"/Users/sergiobayona/.rvm/gems/ruby-1.8.7-p72/specifications/columnize-0.3.1.gemspec", :load_paths=>["/Users/sergiobayona/.rvm/gems/ruby-1.8.7-p72/gems/columnize-0.3.1/lib"], :name=>"columnize"},
        {:loaded_from=>"/Users/sergiobayona/.rvm/gems/ruby-1.8.7-p72/specifications/haml-2.2.22.gemspec", :load_paths=>["/Users/sergiobayona/.rvm/gems/ruby-1.8.7-p72/gems/haml-2.2.22/lib"], :name=>"haml"},
        {:loaded_from=>"/Users/sergiobayona/.bundle/ruby/1.8/specifications/compass-0.10.0.rc1.gemspec", :load_paths=>["/Users/sergiobayona/.bundle/ruby/1.8/gems/compass-0.10.0.rc1/lib"], :name=>"compass"},
        {:loaded_from=>"/Users/sergiobayona/.bundle/ruby/1.8/bundler/gems/factory_girl-511843606ed9fcb0d1005a7b7b4e9598b07eae20-feac7298352a83fef0717d8beadd2eda9aabfe56/factory_girl.gemspec", :load_paths=>["/Users/sergiobayona/.bundle/ruby/1.8/bundler/gems/factory_girl-511843606ed9fcb0d1005a7b7b4e9598b07eae20-feac7298352a83fef0717d8beadd2eda9aabfe56/lib"], :name=>"factory_girl"},
        {:loaded_from=>"/Users/sergiobayona/.bundle/ruby/1.8/specifications/hirb-0.3.1.gemspec", :load_paths=>["/Users/sergiobayona/.bundle/ruby/1.8/gems/hirb-0.3.1/lib"], :name=>"hirb"},
        {:loaded_from=>"/Users/sergiobayona/.rvm/gems/ruby-1.8.7-p72/specifications/linecache-0.43.gemspec", :load_paths=>["/Users/sergiobayona/.rvm/gems/ruby-1.8.7-p72/gems/linecache-0.43/lib"], :name=>"linecache"},
        {:loaded_from=>"/Users/sergiobayona/.bundle/ruby/1.8/specifications/mocha-0.9.8.gemspec", :load_paths=>["/Users/sergiobayona/.bundle/ruby/1.8/gems/mocha-0.9.8/lib"], :name=>"mocha"},
        {:loaded_from=>"/Users/sergiobayona/.bundle/ruby/1.8/specifications/mongo-0.19.1.gemspec", :load_paths=>["/Users/sergiobayona/.bundle/ruby/1.8/gems/mongo-0.19.1/lib"], :name=>"mongo"},
        {:loaded_from=>"/Users/sergiobayona/.bundle/ruby/1.8/specifications/mongo_ext-0.19.1.gemspec", :load_paths=>["/Users/sergiobayona/.bundle/ruby/1.8/gems/mongo_ext-0.19.1/ext"], :name=>"mongo_ext"},
        {:loaded_from=>"/Users/sergiobayona/.bundle/ruby/1.8/specifications/will_paginate-3.0.pre.gemspec", :load_paths=>["/Users/sergiobayona/.bundle/ruby/1.8/gems/will_paginate-3.0.pre/lib"], :name=>"will_paginate"},
        {:loaded_from=>"/Users/sergiobayona/.bundle/ruby/1.8/bundler/gems/mongoid-7c52c9062e8404a8881d39f6d2b48690383a9f58-85500b7134b98c38bee73c140b2189bad55cb1f9/mongoid.gemspec", :load_paths=>["/Users/sergiobayona/.bundle/ruby/1.8/bundler/gems/mongoid-7c52c9062e8404a8881d39f6d2b48690383a9f58-85500b7134b98c38bee73c140b2189bad55cb1f9/lib"], :name=>"mongoid"},
        {:loaded_from=>"/Users/sergiobayona/.bundle/ruby/1.8/specifications/mysql-2.8.1.gemspec", :load_paths=>["/Users/sergiobayona/.bundle/ruby/1.8/gems/mysql-2.8.1/lib", "/Users/sergiobayona/.bundle/ruby/1.8/gems/mysql-2.8.1/ext"], :name=>"mysql"},
        {:loaded_from=>"/Users/sergiobayona/.bundle/ruby/1.8/specifications/nokogiri-1.4.1.gemspec", :load_paths=>["/Users/sergiobayona/.bundle/ruby/1.8/gems/nokogiri-1.4.1/lib", "/Users/sergiobayona/.bundle/ruby/1.8/gems/nokogiri-1.4.1/ext"], :name=>"nokogiri"},
        {:loaded_from=>"/Users/sergiobayona/.rvm/gems/ruby-1.8.7-p72/specifications/thor-0.13.4.gemspec", :load_paths=>["/Users/sergiobayona/.rvm/gems/ruby-1.8.7-p72/gems/thor-0.13.4/lib"], :name=>"thor"},
        {:loaded_from=>"/Users/sergiobayona/.rvm/gems/ruby-1.8.7-p72/specifications/railties-3.0.0.beta.gemspec", :load_paths=>["/Users/sergiobayona/.rvm/gems/ruby-1.8.7-p72/gems/railties-3.0.0.beta/lib"], :name=>"railties"},
        {:loaded_from=>"/Users/sergiobayona/.rvm/gems/ruby-1.8.7-p72/specifications/rails-3.0.0.beta.gemspec", :load_paths=>["/Users/sergiobayona/.rvm/gems/ruby-1.8.7-p72/gems/rails-3.0.0.beta/"], :name=>"rails"},
        {:loaded_from=>"/Users/sergiobayona/.bundle/ruby/1.8/specifications/rspec-core-2.0.0.beta.4.gemspec", :load_paths=>["/Users/sergiobayona/.bundle/ruby/1.8/gems/rspec-core-2.0.0.beta.4/lib"], :name=>"rspec-core"},
        {:loaded_from=>"/Users/sergiobayona/.bundle/ruby/1.8/specifications/rspec-expectations-2.0.0.beta.4.gemspec", :load_paths=>["/Users/sergiobayona/.bundle/ruby/1.8/gems/rspec-expectations-2.0.0.beta.4/lib"], :name=>"rspec-expectations"},
        {:loaded_from=>"/Users/sergiobayona/.bundle/ruby/1.8/specifications/rspec-mocks-2.0.0.beta.4.gemspec", :load_paths=>["/Users/sergiobayona/.bundle/ruby/1.8/gems/rspec-mocks-2.0.0.beta.4/lib"], :name=>"rspec-mocks"},
        {:loaded_from=>"/Users/sergiobayona/.bundle/ruby/1.8/specifications/rspec-2.0.0.beta.4.gemspec", :load_paths=>["/Users/sergiobayona/.bundle/ruby/1.8/gems/rspec-2.0.0.beta.4/lib"], :name=>"rspec"},
        {:loaded_from=>"/Users/sergiobayona/.bundle/ruby/1.8/specifications/webrat-0.7.0.gemspec", :load_paths=>["/Users/sergiobayona/.bundle/ruby/1.8/gems/webrat-0.7.0/lib"], :name=>"webrat"},
        {:loaded_from=>"/Users/sergiobayona/.bundle/ruby/1.8/specifications/rspec-rails-2.0.0.beta.4.gemspec", :load_paths=>["/Users/sergiobayona/.bundle/ruby/1.8/gems/rspec-rails-2.0.0.beta.4/lib"], :name=>"rspec-rails"},
        {:loaded_from=>"/Users/sergiobayona/.rvm/gems/ruby-1.8.7-p72/specifications/ruby-debug-base-0.10.3.gemspec", :load_paths=>["/Users/sergiobayona/.rvm/gems/ruby-1.8.7-p72/gems/ruby-debug-base-0.10.3/lib"], :name=>"ruby-debug-base"},
        {:loaded_from=>"/Users/sergiobayona/.rvm/gems/ruby-1.8.7-p72/specifications/ruby-debug-0.10.3.gemspec", :load_paths=>["/Users/sergiobayona/.rvm/gems/ruby-1.8.7-p72/gems/ruby-debug-0.10.3/cli"], :name=>"ruby-debug"},
      ].map do |hash|
    if hash[:virtual_spec]
      spec = eval(hash[:virtual_spec], binding, "<virtual spec for '#{hash[:name]}'>")
    else
      dir = File.dirname(hash[:loaded_from])
      spec = Dir.chdir(dir){ eval(File.read(hash[:loaded_from]), binding, hash[:loaded_from]) }
    end
    spec.loaded_from = hash[:loaded_from]
    spec.require_paths = hash[:load_paths]
    spec
  end

  extend SharedHelpers

  def self.configure_gem_path_and_home(specs)
    # Fix paths, so that Gem.source_index and such will work
    paths = specs.map{|s| s.installation_path }
    paths.flatten!; paths.compact!; paths.uniq!; paths.reject!{|p| p.empty? }
    ENV['GEM_PATH'] = paths.join(File::PATH_SEPARATOR)
    ENV['GEM_HOME'] = paths.first
    Gem.clear_paths
  end

  def self.match_fingerprint
    print = Digest::SHA1.hexdigest(File.read(File.expand_path('../../Gemfile', __FILE__)))
    unless print == FINGERPRINT
      abort 'Gemfile changed since you last locked. Please `bundle lock` to relock.'
    end
  end

  def self.setup(*groups)
    match_fingerprint
    clean_load_path
    cripple_rubygems(SPECS)
    configure_gem_path_and_home(SPECS)
    SPECS.each do |spec|
      Gem.loaded_specs[spec.name] = spec
      $LOAD_PATH.unshift(*spec.require_paths)
    end
  end

  def self.require(*groups)
    groups = [:default] if groups.empty?
    groups.each do |group|
      (AUTOREQUIRES[group.to_sym] || []).each do |file, explicit|
        if explicit
          Kernel.require file
        else
          begin
            Kernel.require file
          rescue LoadError
          end
        end
      end
    end
  end

  # Setup bundle when it's required.
  setup
end
