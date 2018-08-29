# I2P in Docker

This is the Java I2P router in Docker.

## Usage

`docker run -v ~/.i2p:/var/lib/i2p -p 127.0.0.1:4444:4444 -p 127.0.0.1:6668:6668 -p 127.0.0.1:7657:7657 geti2p/i2p`

### Common problems

If you use Fedora or other selinux enabled OS and get ```mkdir: cannot create directory ‘/var/lib/i2p/.i2p’: Permission denied``` run commands
```shell
setenforce 0
chcon -Rt svit_sandbox_file_t $HOME/.i2p
```
