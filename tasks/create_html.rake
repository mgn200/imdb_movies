namespace :html_layout do
  desc 'Create required directories and files in the current folder'
  task :make_files do
    ImdbPlayfield.create_data_files
  end

  task :build_html do
    ImdbPlayfield::HamlBuilder.new.build_html
  end
end
