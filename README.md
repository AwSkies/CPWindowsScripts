# Scripts for CyberPatriot
## Windows 10 and Server2019
Made by CyberPatriot team of Sharon High School, number 14-3178
## To Run
Open a `Windows Commands Prompt` window as an administrator, CD into the working directory, and run `secure.bat` (simply selecting to run the file as an administrator does not work, since it will open it with a working directory of `C:\WINDOWS\system32\`). When prompted, type `y` for yes, `n` for no, and `c` to stop execution.
## Functions
### Enable Firewall
It enables the firewall.
### Services
Allows for the disabling of services. If chosen, the user will be prompted with either manual or automatic mode.
#### Manual Mode
Steps through each individual service and disables them. The user is able to skip disabling each service.  
Manual mode is *HIGHLY RECOMMENDED* as there are often critical services that the user does not want to disable in the list of services.
#### Automatic Mode
Disables every service on the list
### Remote Desktop
Disables remote desktop. This is an important service that gets its own category, as it has many different services associated with it and is often made a critical service.
### Registry Keys
Manages registry keys and sets very very many settings. Be careful when using it, as it changes many things and may mess up something specific to the competition scenario.
### Import Policies
Imports Local Group Policy Objects from `.\Policies\`.
### Guest and Admin
Disables `Guest` and `Administrator` default accounts.
### User Audit
Current Functionality: Changes the password of every user except for the current one to `q1W@e3R$t5Y^u7I*o9`.
Future Functionality: Reads users from `authorizedusers.txt` and deletes and/or creates users to match the list.
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
Steps through each individual file type, then file. The user is able to skip both entire file types and individual files.  
Manual mode is *HIGHLY RECOMMENDED* as automatic mode may risk deleting (irreversably) media that is a part of some programs.
#### Automatic Mode
Deletes every file found with a disallowed type.