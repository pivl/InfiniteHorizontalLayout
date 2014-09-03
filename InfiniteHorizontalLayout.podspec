Pod::Spec.new do |s|
  s.name = 'InfiniteHorizontalLayout'
  s.version = '0.0.1'
  s.license = 'MIT'
  s.summary = 'Infinite Horizontal Collection View Custom Layout for endless scrolling with defined number of items'
  s.homepage	 = 'https://github.com/pivl/InfiniteHorizontalLayout'
  
  s.requires_arc = true
  s.platform = :ios, '6.0'
  
  s.authors = { 'Pavel Stasyuk' => 'p.stasyuk@gmail.com' }
  
  s.source_files = 'InfiniteHorizontalLayout/*.{h,m}'
  s.source = { :git => 'https://github.com/pivl/InfiniteHorizontalLayout.git', :tag => '0.0.1' }  
end
