#
# MMMLog. Part of MMMTemple.
# Copyright (C) 2020-2025 Monks. All rights reserved.
#

Pod::Spec.new do |s|

	s.name = "MMMLog"
	s.version = "1.4.2"
	s.description = s.summary = "Practical simple logging."
	s.homepage = "https://github.com/mediamonks/MMMLog"
	s.license = "MIT"
	s.authors = "MediaMonks"
	s.source = { :git => "https://github.com/mediamonks/MMMLog.git", :tag => s.version.to_s }

	s.ios.deployment_target = '11.0'
	s.watchos.deployment_target = '2.0'
	s.tvos.deployment_target = '9.0'
	s.osx.deployment_target = '10.10'

	s.swift_versions = '4.2'
	s.static_framework = true
	s.pod_target_xcconfig = {
		"DEFINES_MODULE" => "YES"
	}

	s.subspec 'ObjC' do |ss|
		ss.source_files = 'Sources/MMMLogObjC/**/*'
	end

	s.subspec 'Swift' do |ss|
		ss.source_files = 'Sources/MMMLog/**/*'
		ss.dependency 'MMMLog/ObjC'
	end

	s.default_subspec = 'ObjC', 'Swift'
end
