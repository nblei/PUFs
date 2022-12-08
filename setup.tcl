set HOME [getenv HOME]
set project_dir [getenv PROJECT_DIR]
set IGZO_LIB ${HOME}/Libraries/PragmaticV2_0.db
set include_dir "${project_dir}/inc"
set search_path [concat $search_path $include_dir]
