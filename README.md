# README

This Rails application is a simple demo for getting SSL running for local development and test environments.

## Requirements

Below is a list of binaries and gems with the versions used in this demo. It may be possible to make this work with other relatively recent versions of these tools, though your mileage may vary.

### Binaries

```
$ openssl version
LibreSSL 2.2.7

$ ruby -v
ruby 2.4.1p111 (2017-03-22 revision 58053) [x86_64-darwin16]

$ /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --version
Google Chrome 68.0.3440.106

$ /Applications/Firefox.app/Contents/MacOS/firefox --version
Mozilla Firefox 60.0.1

$ ~/.webdrivers/chromedriver -v
ChromeDriver 2.41.578706 (5f725d1b4f0a4acbf5259df887244095596231db)

$ ~/.webdrivers/geckodriver --version
geckodriver 0.21.0
```
### Gemfile

```ruby
gem 'rails', '~> 5.2.1'
gem 'puma', '~> 3.12'
gem 'webpacker', '~> 3.5.5' # optional

group :test do
  gem 'capybara', '~> 3.5.1'
  gem 'selenium-webdriver', '~> 3.14.0'
  gem 'webdrivers', '~> 3.3.3'
  gem 'rspec-rails', '~> 3.8.0' # optional
end
```

## Register a local top level domain

For custom "pretty" wildcard domains, you can use a domain name registered to loop back to the local IP `127.0.0.1` like `lvh.me` or you can run `dnsmasq` locally to achieve the same effect for which ever domain you want.

Install and start dnsmasq
```
brew install dnsmasq
mkdir -pv $(brew --prefix)/etc
sudo cp -v $(brew --prefix dnsmasq)/homebrew.mxcl.dnsmasq.plist /Library/LaunchDaemons
brew services start dnsmasq
sudo mkdir -pv /etc/resolver
```
Add a resolver for a TLD you'd like to resolve locally. In this example, we'll use the username returned from `whoami`.
```
local_tld=$(whoami)
echo "address=/.$local_tld/127.0.0.1" | sudo tee -a $(brew --prefix)/etc/dnsmasq.conf
echo "nameserver 127.0.0.1" | sudo tee /etc/resolver/$local_tld
```

## Generate a wildcard SSL certificate

To generate a self-signed SSL certificate that will work for both arbitrary subdomains and the domain appex, we need make use of the Subject Alternative Name X.509 extension via a configuration file.

```bash
name=localhost.$(whoami)
openssl req \
  -new \
  -newkey rsa:2048 \
  -sha256 \
  -days 3650 \
  -nodes \
  -x509 \
  -keyout $name.key \
  -out $name.crt \
  -config <(cat <<-EOF
  [req]
  distinguished_name = req_distinguished_name
  x509_extensions = v3_req
  prompt = no
  [req_distinguished_name]
  CN = $name
  [v3_req]
  keyUsage = keyEncipherment, dataEncipherment
  extendedKeyUsage = serverAuth
  subjectAltName = @alt_names
  [alt_names]
  DNS.1 = $name
  DNS.2 = *.$name
EOF
)
```
Move the generated files to a location of your choosing, such as the `config` directory of your Rails project:
```
$ mv localhost.ross.crt localhost.ross.key config/ssl
```
Finally, we can instruct Keychain to trust are newly generated certificate. Some browsers like Chrome will rely on the System settings
```
$ sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain config/ssl/localhost.ross.crt
```
### Server configuration

If you're running Nginx locally to reverse proxy requests for `https://localhost.ross` to your local Rails server, you can configure it to handle SSL requests using your key/crt file pair.

Without Nginx, you can boot the Rails Puma server so that it will bind to our local domain name over SSL:

```
bin/rails s -b 'ssl://127.0.0.1:3000?key=config/ssl/localhost.ross.key&cert=config/ssl/localhost.ross.crt'
```
A similar command can be found in the Procfile for use with `foreman` locally.

## Acknowledgements

The guide for setting up SSL for local development is based off of Jed Schmidt's excellent
