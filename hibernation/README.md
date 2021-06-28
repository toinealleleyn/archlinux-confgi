## Sources

### Configuration
- https://wiki.archlinux.org/title/Swap#Swap_file
- https://wiki.archlinux.org/title/Power_management/Suspend_and_hibernate#Hibernation

### Size of the swap file

From https://help.ubuntu.com/community/SwapFaq#How_much_swap_do_I_need.3F:

```
For more modern systems (>1GB), your swap space should be at a minimum be equal to your physical memory (RAM) size "if you use hibernation", otherwise you need a minimum of round(sqrt(RAM)) and a maximum of twice the amount of RAM. The only downside to having more swap space than you will actually use, is the disk space you will be reserving for it.
```

The script creates a swap file with the size of `RAM + sqrt(RAM)` to have enough space for hibernation and normal swapping. 
