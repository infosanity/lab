# configparser

## Import
```python
import configparser
```

## Example Config
Taken from vendor example [docs](https://docs.python.org/3/library/configparser.html)
```config
[DEFAULT]
ServerAliveInterval = 45
Compression = yes
CompressionLevel = 9
ForwardX11 = yes

[forge.example]
User = hg

[topsecret.server.example]
Port = 50022
ForwardX11 = no
```

## Read from file
```python
config = configparser.ConfigParser()
config.read("/path/to/file.cfg")
```

### Load Section as dict
```python
conf_variable = config._sections['DEFAULT']
# conf_variable is dict

print(conf_variable.get("ForwardX11"))
# prints "yes"
```