# Scripts for CyberPatriot
## Windows 10 and Server2019
Made by CyberPatriot team of Sharon High School, number 14-3178
## To Run
Run `secure.bat` as an administrator, either by selecting run as administrator or by CDing into the directory and running the file. When prompted, type `y` for yes, `n` for no, and `c` to stop execution.
## Functions
### Enable Firewall
Enables the firewall.
### Services
Allows for the disabling of services. If chosen, the user will be prompted with either manual or automatic mode.
#### Manual Mode
Steps through each individual service and disables them. The user is able to skip disabling each service.
#### Automatic Mode
Disables every service on the list.  
**Manual mode is *HIGHLY RECOMMENDED* as there are often critical services on the list that the user does not want to disable.**
### Remote Desktop
Disables remote desktop. This is an important service that gets its own category, as it has many different services associated with it and is often made a critical service.
### Registry Keys
Manages registry keys and sets very many settings. Be careful when using it, as it changes many things and may mess up something specific to the competition scenario.
### Import Policies
Imports Local Group Policy Objects from `.\Policies\`.
### Guest and Admin
Disables `Guest` and `Administrator` default accounts.
### User Audit
#### Authorized Users
Reads users from `authorizedusers.txt`, deletes all users not on the list, and adds users on the list but missing from the computer (with a password of `q1W@e3R$t5Y^u7I*o9`). When adding missing users, the user will be prompted if they want to make a password longer than 14 characters, since Windows versions older than Windows 2000 will be unable to use the account.  
**Be sure that all built-in accounts (`Administrator`, `Guest`, `DefaultAccount`, `WDAGUtilityAccount`) are in the list or else it will try and fail to delete them. The accounts are already there in the list, so just don't remove them.** It's recommended to modify `authorizedusers.txt` only after copying the scripts folder into the VM.
#### Admins
Reads users from `admins.txt`, removes all users not on the list from the Administrators group, and adds users on the list but missing from the group.  
**Be sure that the built-in `Administrator` account is on the list.The account is already there in the list, so just don't remove it.** It's recommended to modify `admins.txt` only after copying the scripts folder into the VM.
### User Passwords
Changes the password of every user except for the one currently in use to `q1W@e3R$t5Y^u7I*o9`.
### Disallowed Media Files
Deletes files of type:
- mp3
- mov
- mp4
- avi
- mpg
- mpeg
- flac
- m4a
- flv
- ogg
- gif
- png
- jpg
- jpeg  

recursively in the `C:\Users\` directory. If chosen, the user will be prompted with either manual or automatic mode.
#### Manual Mode
Steps through each individual file type, then file. The user is prompted whether they wish to search for files of a certain file type, then prompted whether or not they want to delete each file found. They may also press `O` to open the file's location in the file explorer. 
#### Automatic Mode
Deletes every file found with a disallowed type.  
**Manual mode is *HIGHLY RECOMMENDED* as automatic mode may risk deleting (irreversably) media that is a part of some programs.**