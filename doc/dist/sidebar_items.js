sidebarNodes={"exceptions":[{"id":"HangmanError","title":"HangmanError","functions":[{"id":"exception/1","anchor":"exception/1"},{"id":"message/1","anchor":"message/1"}]}],"extras":[{"id":"api-reference","title":"API Reference","headers":[]}],"modules":[{"id":"Action","title":"Action","functions":[{"id":"perform/2","anchor":"perform/2"}]},{"id":"CLI","title":"CLI","functions":[{"id":"main/1","anchor":"main/1"}]},{"id":"Chunks","title":"Chunks","functions":[{"id":"add/2","anchor":"add/2"},{"id":"container_size/0","anchor":"container_size/0"},{"id":"count/1","anchor":"count/1"},{"id":"get_words_lazy/1","anchor":"get_words_lazy/1"},{"id":"info/1","anchor":"info/1"},{"id":"key/1","anchor":"key/1"},{"id":"new/1","anchor":"new/1"},{"id":"new/2","anchor":"new/2"},{"id":"size/1","anchor":"size/1"}],"types":[{"id":"binary_chunk/0","anchor":"t:binary_chunk/0"},{"id":"t/0","anchor":"t/0"}]},{"id":"Chunks.Stream","title":"Chunks.Stream","functions":[{"id":"transform/3","anchor":"transform/3"}]},{"id":"Counter","title":"Counter","functions":[{"id":"add_letters/2","anchor":"add_letters/2"},{"id":"add_unique_letters/2","anchor":"add_unique_letters/2"},{"id":"add_words/2","anchor":"add_words/2"},{"id":"add_words/3","anchor":"add_words/3"},{"id":"delete/1","anchor":"delete/1"},{"id":"delete/2","anchor":"delete/2"},{"id":"empty?/1","anchor":"empty?/1"},{"id":"equal?/2","anchor":"equal?/2"},{"id":"inc_by/3","anchor":"inc_by/3"},{"id":"items/1","anchor":"items/1"},{"id":"most_common/2","anchor":"most_common/2"},{"id":"most_common_key/2","anchor":"most_common_key/2"},{"id":"new/0","anchor":"new/0"},{"id":"new/1","anchor":"new/1"}],"types":[{"id":"key/0","anchor":"t:key/0"},{"id":"t/0","anchor":"t/0"},{"id":"value/0","anchor":"t:value/0"}]},{"id":"Dictionary","title":"Dictionary","functions":[{"id":"big/0","anchor":"big/0"},{"id":"chunked/0","anchor":"chunked/0"},{"id":"chunks_file_delimiter/0","anchor":"chunks_file_delimiter/0"},{"id":"grouped/0","anchor":"grouped/0"},{"id":"paths/0","anchor":"paths/0"},{"id":"regular/0","anchor":"regular/0"},{"id":"sorted/0","anchor":"sorted/0"},{"id":"unsorted/0","anchor":"unsorted/0"}],"types":[{"id":"kind/0","anchor":"t:kind/0"},{"id":"transform/0","anchor":"t:transform/0"}]},{"id":"Dictionary.Cache","title":"Dictionary.Cache","functions":[{"id":"lookup/2","anchor":"lookup/2"},{"id":"setup/1","anchor":"setup/1"},{"id":"start_link/1","anchor":"start_link/1"},{"id":"stop/0","anchor":"stop/0"},{"id":"stop/1","anchor":"stop/1"}]},{"id":"Dictionary.File","title":"Dictionary.File","functions":[{"id":"make_file_transform/1","anchor":"make_file_transform/1"},{"id":"transform/3","anchor":"transform/3"},{"id":"transform_handler/3","anchor":"transform_handler/3"}]},{"id":"Dictionary.File.Stream","title":"Dictionary.File.Stream","functions":[{"id":"delete/1","anchor":"delete/1"},{"id":"file_handler/2","anchor":"file_handler/2"},{"id":"gets_lazy/1","anchor":"gets_lazy/1"},{"id":"new/2","anchor":"new/2"}],"types":[{"id":"mode/0","anchor":"t:mode/0"},{"id":"t/0","anchor":"t/0"}]},{"id":"Game","title":"Game","functions":[{"id":"guess/2","anchor":"guess/2"},{"id":"info/1","anchor":"info/1"},{"id":"load/3","anchor":"load/3"},{"id":"mystery_letter/0","anchor":"mystery_letter/0"},{"id":"status/1","anchor":"status/1"}],"types":[{"id":"id/0","anchor":"t:id/0"},{"id":"result/0","anchor":"t:result/0"},{"id":"t/0","anchor":"t/0"}]},{"id":"Game.Pid.Cache","title":"Game.Pid.Cache","functions":[{"id":"get_server_pid/2","anchor":"get_server_pid/2"},{"id":"start_link/0","anchor":"start_link/0"}]},{"id":"Game.Server","title":"Game.Server","functions":[{"id":"guess/2","anchor":"guess/2"},{"id":"load/4","anchor":"load/4"},{"id":"secret_length/1","anchor":"secret_length/1"},{"id":"start_link/3","anchor":"start_link/3"},{"id":"status/1","anchor":"status/1"},{"id":"stop/1","anchor":"stop/1"},{"id":"whereis/1","anchor":"whereis/1"}],"types":[{"id":"id/0","anchor":"t:id/0"}]},{"id":"Guess","title":"Guess"},{"id":"Pass","title":"Pass"},{"id":"Pass.Cache","title":"Pass.Cache","functions":[{"id":"get/2","anchor":"get/2"},{"id":"get/3","anchor":"get/3"},{"id":"start_link/0","anchor":"start_link/0"},{"id":"stop/1","anchor":"stop/1"}],"types":[{"id":"key/0","anchor":"t:key/0"}]},{"id":"Pass.Writer","title":"Pass.Writer","functions":[{"id":"start_link/0","anchor":"start_link/0"},{"id":"write/2","anchor":"write/2"}]},{"id":"Pass.Writer.Pool","title":"Pass.Writer.Pool","callbacks":[{"id":"init/1","anchor":"c:init/1"}],"functions":[{"id":"init/1","anchor":"init/1"},{"id":"start_link/1","anchor":"start_link/1"}]},{"id":"Pass.Writer.Worker","title":"Pass.Writer.Worker","functions":[{"id":"start_link/1","anchor":"start_link/1"},{"id":"stop/1","anchor":"stop/1"},{"id":"write/3","anchor":"write/3"}]},{"id":"Pattern","title":"Pattern","functions":[{"id":"update/3","anchor":"update/3"}]},{"id":"Player","title":"Player","functions":[{"id":"choices/3","anchor":"choices/3"},{"id":"delete/1","anchor":"delete/1"},{"id":"game_lost?/1","anchor":"game_lost?/1"},{"id":"game_won?/1","anchor":"game_won?/1"},{"id":"games_over?/1","anchor":"games_over?/1"},{"id":"games_summary/1","anchor":"games_summary/1"},{"id":"guess/1","anchor":"guess/1"},{"id":"guess/2","anchor":"guess/2"},{"id":"human/0","anchor":"human/0"},{"id":"info/1","anchor":"info/1"},{"id":"last_word?/1","anchor":"last_word?/1"},{"id":"new/4","anchor":"new/4"},{"id":"robot/0","anchor":"robot/0"},{"id":"start/1","anchor":"start/1"},{"id":"status/2","anchor":"status/2"}],"types":[{"id":"kind/0","anchor":"t:kind/0"},{"id":"result/0","anchor":"t:result/0"},{"id":"t/0","anchor":"t/0"}]},{"id":"Player.Events","title":"Player.Events","functions":[{"id":"notify_games_over/3","anchor":"notify_games_over/3"},{"id":"notify_guess/3","anchor":"notify_guess/3"},{"id":"notify_length/2","anchor":"notify_length/2"},{"id":"notify_start/2","anchor":"notify_start/2"},{"id":"notify_status/2","anchor":"notify_status/2"},{"id":"start_link/1","anchor":"start_link/1"},{"id":"stop/1","anchor":"stop/1"},{"id":"terminate/2","anchor":"terminate/2"}]},{"id":"Player.Game","title":"Player.Game","functions":[{"id":"rounds_handler/2","anchor":"rounds_handler/2"},{"id":"run/5","anchor":"run/5"},{"id":"setup/4","anchor":"setup/4"},{"id":"start_player/4","anchor":"start_player/4"}]},{"id":"Player.Logger.Handler","title":"Player.Logger.Handler","callbacks":[{"id":"handle_event/2","anchor":"c:handle_event/2"},{"id":"init/1","anchor":"c:init/1"},{"id":"terminate/2","anchor":"c:terminate/2"}]},{"id":"Reduction","title":"Reduction"},{"id":"Reduction.Engine","title":"Reduction.Engine","functions":[{"id":"reduce/3","anchor":"reduce/3"},{"id":"start_link/0","anchor":"start_link/0"}]},{"id":"Reduction.Engine.Pool","title":"Reduction.Engine.Pool","callbacks":[{"id":"init/1","anchor":"c:init/1"}],"functions":[{"id":"init/1","anchor":"init/1"},{"id":"start_link/1","anchor":"start_link/1"}]},{"id":"Reduction.Engine.Worker","title":"Reduction.Engine.Worker","callbacks":[{"id":"terminate/2","anchor":"c:terminate/2"}],"functions":[{"id":"reduce_and_store/4","anchor":"reduce_and_store/4"},{"id":"start_link/1","anchor":"start_link/1"}]},{"id":"Reduction.Options","title":"Reduction.Options","functions":[{"id":"reduce_key/2","anchor":"reduce_key/2"},{"id":"regex_match_key/2","anchor":"regex_match_key/2"}]},{"id":"Round","title":"Round","functions":[{"id":"augment_choices/2","anchor":"augment_choices/2"},{"id":"context/1","anchor":"context/1"},{"id":"guess/2","anchor":"guess/2"},{"id":"setup/1","anchor":"setup/1"},{"id":"setup/2","anchor":"setup/2"},{"id":"status/1","anchor":"status/1"},{"id":"update/2","anchor":"update/2"},{"id":"update/3","anchor":"update/3"}],"types":[{"id":"result/0","anchor":"t:result/0"},{"id":"t/0","anchor":"t:t/0"}]},{"id":"Strategy","title":"Strategy","functions":[{"id":"choose_letters/2","anchor":"choose_letters/2"},{"id":"get_guessed/1","anchor":"get_guessed/1"},{"id":"info/1","anchor":"info/1"},{"id":"last_word/1","anchor":"last_word/1"},{"id":"letter_in_most_common/3","anchor":"letter_in_most_common/3"},{"id":"make_guess/1","anchor":"make_guess/1"},{"id":"most_common_letter/2","anchor":"most_common_letter/2"},{"id":"most_common_letter_and_counts/2","anchor":"most_common_letter_and_counts/2"},{"id":"new/0","anchor":"new/0"},{"id":"retrieve_best_letter/1","anchor":"retrieve_best_letter/1"},{"id":"update/2","anchor":"update/2"},{"id":"update/3","anchor":"update/3"}],"types":[{"id":"result/0","anchor":"t:result/0"},{"id":"t/0","anchor":"t/0"}]}],"protocols":[]}