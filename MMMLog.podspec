#
# MMMLog.
# Copyright (C) 2020 MediaMonks. All rights reserved.
#

Pod::Spec.new do |s|
	
	s.name = "MMMLog"
	s.version = "0.4.4"
	s.description = s.summary = "Practical simple logging."
	s.homepage = "https://github.com/mediamonks/MMMLog"
	s.license = "MIT"
	s.authors = "MediaMonks"
	s.source = { :git => "https://github.com/mediamonks/MMMLog.git", :tag => s.version.to_s }
	
	s.ios.deployment_target = '11.0'
	s.watchos.deployment_target = '2.0'
	
	s.swift_versions = '4.2'
	s.static_framework = true
	s.pod_target_xcconfig = {
		"DEFINES_MODULE" => "YES"
	}

	s.subspec 'ObjC' do |ss|		
		ss.source_files = 'MMMLog/ObjC/**/*'
	end
	
	s.subspec 'Swift' do |ss|
		ss.source_files = 'MMMLog/Swift/**/*'
		ss.dependency 'MMMLog/ObjC'
	end
	
	s.default_subspec = 'Swift'	
end
