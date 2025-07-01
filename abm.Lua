local range = 0.015
local is_on = true

local gui_position_x_scale_offset = 0x3a8

local function nanami_cutter_logic()

    local live_folder = waitforchild(Workspace, "Live", 15)
    if not live_folder then
        warn("Could not find 'Live' folder; script will terminate.")
        return 
    end

    while is_on do
        local nanami_gui = findfirstdescendant(live_folder, "NanamiCutGUI")

        if nanami_gui then
            local main_bar = waitforchild(nanami_gui, "MainBar", 5)
            local cutter = main_bar and waitforchild(main_bar, "Cutter", 5)
            local goal = main_bar and waitforchild(main_bar, "Goal", 5)

            if cutter and goal then

                while findfirstancestor(cutter, "Live") do
                    if not is_on then break end 

                    local cutter_pos_x = getmemoryvalue(cutter, gui_position_x_scale_offset, "float")
                    local goal_pos_x = getmemoryvalue(goal, gui_position_x_scale_offset, "float")

                    if cutter_pos_x and goal_pos_x then

                        local distance = math.abs(cutter_pos_x - goal_pos_x)

                        if distance < range then
                            mouse1click()

                            repeat
                                wait()
                                cutter_pos_x = getmemoryvalue(cutter, gui_position_x_scale_offset, "float")
                                distance = cutter_pos_x and math.abs(cutter_pos_x - goal_pos_x)
                            until not is_on or not distance or distance >= range

                            break 
                        end
                    end

                    wait() 
                end
            end
        end

        wait(0.2) 
    end
end

thread.create("nanami_cutter_thread", nanami_cutter_logic)
