# Ledger::Tools
[![Build Status](https://travis-ci.org/mindreframer/ledger-tools.png)](https://travis-ci.org/mindreframer/ledger-tools)




  Some scripts around [Ledger-CLI](http://www.ledger-cli.org/)

    - ledger-formatter:
        will sort and indent your ledger file.




## Installation

    $ gem install ledger-tools

## Usage

### In your libraries
    > require 'ledger/tools'


### ledger-formatter
    $ ledger-formatter -f /your/ledger/data.ledger

### Run tests
    $ sh/test

### Start `pry`-console with ledger-tools loaded
    $ sh/c

### Start `pry`-console with ledger-tools loaded (in test `ENV`)
    $ sh/c test



## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
