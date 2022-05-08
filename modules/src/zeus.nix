{ config, pkgs, ... }:

{
  # Create zeus user account 
  users.users.zeus = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-dss AAAAB3NzaC1kc3MAAACBAI1qVWFCWxbLnwVR0T+QPKBj8lCyPUZFPDBMNIcDCNPe8EtNHUWh5gfju+46QHZwR8mjFcE8t3cMLDDoTCcnKzNgjTqhY6EeHfzvX6VQ3mxratQDU+FLoUwEZhkzmEKzDgdV/4vaGApmWH9TnqndEynNtrWijs9WIsO9Wb1yfmzTAAAAFQCzvQnXoysYvIo7cRSRZsBQvSULuQAAAIAyQmNdJ7wQ/W7yIBGfoo8KB14Y60eB7vDoTQOTbxCr74GczM0IuOC0qiXN5vB45G5Z9Lkk7Wyz+ybVM5CMMovFrEElsMC7m6qIiuZpzsOPYtVxAv4vZH0/kgF6oq5stEhA4rtwa7gTkbMHNKIjVVvLjW7eyVvcKVKNnX/bUgJP0gAAAIBuIKvfF5JdbFl/dHBgTVcDOPE5V7LaKdFDWDUf2GuNUFact5+//2c3XqqnAOSYueXFfKzOsvLc3hGstVYz0+9kLsfK1vi/VSTXc4QXico9mhFz1A5C7IUPRRDkTYazNeDiJc8D/XLa2iBmZpbBa7Cd/oJaCJO98mIMA5BnbiZl9w== tl-dss"
      "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAIEA0vP5J+lUryYVR9bRK0sK4YNWp561d7lVtd6gDRVm7jp0ZzCygiXO39KHFo1FjGbFY+VlwE5T+1eRjiwCym4c8L0W+9nPtSi0TyEV9hdaUKRucpTfKInRUcmd8R/nStVtgm9LSXhcwJO8FpaGp+J/xO0HE2otXxDglcGV5QnB6Dc= tl-rsa"
    ];
  };
}
