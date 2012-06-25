# rails-brakeman.com

[![Build Status](https://secure.travis-ci.org/flyerhzm/rails-brakeman.com.png)](http://travis-ci.org/flyerhzm/rails-brakeman.com)

[![Security Status](http://rails-brakeman.com/flyerhzm/rails-brakeman.com.png)](http://rails-brakeman.com/flyerhzm/rails-brakeman.com)

[![Coderwall Endorse](http://api.coderwall.com/flyerhzm/endorsecount.png)](http://coderwall.com/flyerhzm)

[![Click here to lend your support to: rails-brakeman.com and make a donation at www.pledgie.com !](https://www.pledgie.com/campaigns/17431.png?  skin_name=chrome)](http://www.pledgie.com/campaigns/17431)

[rails-brakeman.com][1] is aimed to help developers find out the security issues in their rails codebase.

it is based on [brakeman][2] gem.

## Setup

1. git clone repository

2. copy all config files and change to proper values

```bash
cp config/database.yml.example config/database.yml
cp config/github.yml.example config/github.yml
cp config/mailers.yml.example config/mailers.yml
```

3. setup database

```bash
rake db:create && rake db:migrate
```

4. start server

```bash
rails  s
```

[1]: http://rails-brakeman.com
[2]: https://github.com/presidentbeef/brakeman
