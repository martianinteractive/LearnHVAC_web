Factory.sequence :version do |n|
   "0_99_#{n}"
 end

Factory.define :client_version do |version|
  version.version { Factory.next(:version) }
  version.url 'http://github.com/downloads/danielmcquillen/LearnHVAC_AIR/LearnHVAC_Installer_0_99.15.exe'
  version.release_date 1.day.ago.to_date
end