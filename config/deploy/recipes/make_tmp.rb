task :make_tmp do
	run "mkdir -p #{release_path}/tmp/sessions #{release_path}/tmp/cache #{release_path}/tmp/downloads #{release_path}/tmp/zipfiles"
end

