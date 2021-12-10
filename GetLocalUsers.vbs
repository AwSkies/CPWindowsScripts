Set accounts = GetObject("WinNT://.")
accounts.Filter = Array("user")
For Each user In accounts
  WScript.Echo user.Name
Next