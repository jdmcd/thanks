# Swift Thanks
A project that helps you show your thanks for your dependencies.

# Inspiration
This package was inspired by the wonderful [Symfony Thanks](https://github.com/symfony/thanks).

# Installation
To install, run:

`curl https://raw.githubusercontent.com/mcdappdev/thanks/master/install.sh | bash`

# Github OAuth Key
On first run, Swift Thanks will provide instructions on how to generate a Github OAuth key and will ask you to provide it. This key is stored in a file on your computer and is not transmitted from your computer to any other service (except when using it to authenticate the Github API requests).

# Usage
Currently, Swift Thanks only supports Swift projects that have a `Package.swift`.

Navigate to a swift project directory and call `thanks`. If you want to be generous and also star this repo, you can include the `--self` flag: `thanks --self`.
