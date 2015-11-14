# run this to fix pod install error, don't know why
# sudo gem install cocoapods-deintegrate
# pod deintegrate

use_frameworks!

#pod 'AFNetworking'
#pod 'Parse'
#pod 'Firebase'
#pod 'DateKit'

def shared_pods
#    pod 'AFNetworking'
#    pod 'Mantle'
    pod 'XCGLogger'
end

target 'TipCalc' do
    platform :ios, '9.0'
    shared_pods
end

target 'TipCalc WatchKit Extension' do
    platform :watchos, '2.0'
    shared_pods
end