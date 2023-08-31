---
title: Tailscale VPN on my ASUSwrt-Merlin router
date: 2023-08-31
tags: ["tailscale", "vpn", "router", "asuswrt", "asuswrt-merlin"]
---

Experimenting with [Tailscale](https://tailscale.com/), I like to use my home network router as exit node while I am not at home.

A Reddit thread provided most of the details:
https://www.reddit.com/r/Tailscale/comments/u3m83k/making_tailscale_working_on_my_asus_rtax82u_router/

> ### Making Tailscale working on my Asus RT-AX82U router
>
> Background: I owned an Asus RT-AX82U router, but running in AP mode, so those normal WAN side features like VPN will not be available under this mode, while the router itself has dedicated chip to have WiFi handling, I was thinking some way to give my the main CPU some loading, and finding some ways to put Tailscale on it.
>
> This might be possible for other Asus routers, as long as they have "Asus Merlin" firmware support, my AX82U was just getting this so YAY~ You need to update firmware to Merlin before moving on.
>
> Another thing you need: A USB drive, depends on your usage you can choose whatever you want, since the space needed isn't that much. For me I am just putting a very old USB 2.0 1GB (Yes! 1GB not 1TB) on it, but if anyone else got other usage you might want to have a bigger disk.
>
> Plug the USB drive, SSH to router and install Entware Package Management tool, this is why you need the USB drive, but by default it only uses very little space that's why I am only using 1GB drive.
> 
> Install the following packages:
> ```console
> $ opkg install kmod-tun (this might not be needed, seems newer Entware has it already)
> $ opkg install ca-bundle
> $ opkg install tailscale
> $ opkg install tailscaled
> ```
>
> Once it's done, execute /opt/etc/init.d/S06tailscaled start or reboot (I don't like to reboot that often), profit! Now you can follow the Tailscale Linux CLI guide to do what you need.

A comment in the same threat added some details to start the Tailscale daemon at boot:
https://www.reddit.com/r/Tailscale/comments/u3m83k/making_tailscale_working_on_my_asus_rtax82u_router/ifm4q0r/

> I did the following and Tailscale seems to start on boot with the router now:
> ```console
> nano /jffs/scripts/post-mount
> ```
> Added:
> ```text
> sleep 20
> /opt/etc/init.d/rc.unslung restart
> ```
