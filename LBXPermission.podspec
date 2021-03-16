Pod::Spec.new do |s|
s.name         = 'LBXPermission'
s.version      = '1.1.1'
s.summary      = 'iOS permissions'
s.homepage     = 'https://github.com/MxABC/LBXPermission'
s.license      = 'MIT'
s.authors      = {'lbxia' => 'lbxia20091227@foxmail.com'}
s.platform     = :ios, '8.0'
s.source       = {:git => 'https://github.com/MxABC/LBXPermission.git', :tag => s.version}
s.requires_arc = true
s.default_subspec = 'All'

s.subspec 'All' do |all|
    all.source_files = 'LBXPermissions/*.{h,m}'
end

s.subspec 'Base' do |base|
    base.source_files = 'LBXPermissions/LBXPermissionSetting.{h,m}','LBXPermissions/LBXPermission.{h,m}'
end

s.subspec 'Camera' do |camera|
    camera.source_files = 'LBXPermissions/LBXPermissionCamera.{h,m}'
end

s.subspec 'Photo' do |photo|
    photo.source_files = 'LBXPermissions/LBXPermissionPhotos.{h,m}'
end

s.subspec 'Contact' do |contact|
    contact.source_files = 'LBXPermissions/LBXPermissionContacts.{h,m}'
end

s.subspec 'Location' do |location|
    location.source_files = 'LBXPermissions/LBXPermissionLocation.{h,m}'
end

s.subspec 'Reminder' do |reminder|
    reminder.source_files = 'LBXPermissions/LBXPermissionReminders.{h,m}'
end

s.subspec 'Calendar' do |calendar|
    calendar.source_files = 'LBXPermissions/LBXPermissionCalendar.{h,m}'
end

s.subspec 'Microphone' do |microphone|
    microphone.source_files = 'LBXPermissions/LBXPermissionMicrophone.{h,m}'
end

s.subspec 'Health' do |health|
    health.source_files = 'LBXPermissions/LBXPermissionHealth.{h,m}'
end

s.subspec 'Net' do |net|
    net.source_files = 'LBXPermissions/LBXPermissionNet.{h,m}','LBXPermissions/NetReachability.{h,m}','LBXPermissions/LBXPermissionData.{h,m}'
end

s.subspec 'Tracking' do |tracking|
    tracking.source_files = 'LBXPermissions/LBXPermissionTracking.{h,m}'
end

s.subspec 'Notification' do |notification|
    notification.source_files = 'LBXPermissions/LBXPermissionNotification.{h,m}'
end


end

