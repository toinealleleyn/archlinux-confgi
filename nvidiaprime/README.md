## Sources
- https://download.nvidia.com/XFree86/Linux-x86_64/470.42.01/README/dynamicpowermanagement.html
- https://wiki.archlinux.org/title/PRIME

## Check for succesful configuration.

`cat /proc/driver/nvidia/gpus/domain:bus:device.function/power`
![d3_status](https://user-images.githubusercontent.com/86513427/123815571-e2967e00-d8f6-11eb-8ec4-1c81ada72222.png)

You can run applications with the NVIDIA GPU using `prime-run`.
![Screenshot from 2021-06-29 16-33-56](https://user-images.githubusercontent.com/86513427/123816805-e971c080-d8f7-11eb-81f3-3d3dcb0d5097.png) 
![Screenshot from 2021-06-29 16-33-49](https://user-images.githubusercontent.com/86513427/123816817-eb3b8400-d8f7-11eb-8c4b-4063432d72fb.png)
