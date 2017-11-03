Pod::Spec.new do |s|
s.name         = 'LBXPermission'
s.version      = '1.0.0'
s.summary      = 'iOS permissions'
s.homepage     = 'https://github.com/MxABC/LBXPermission'
s.license      = 'MIT'
s.authors      = {'lbxia' => 'lbxia20091227@foxmail.com'}
s.platform     = :ios, '8.0'
s.source       = {:git => 'https://github.com/MxABC/LBXPermission.git', :tag => s.version}
s.source_files = 'LBXPermissions/*.{h,m}'
s.requires_arc = true
end

