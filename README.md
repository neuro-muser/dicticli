# terminal-dictionary ( UA -> US )

## How to install:

```bash
git clone https://github.com/neuro-muser/dicticli.git
```
### bash
Append this line to your *~/.bashrc*:
```bash
[ "$DISPLAY" ] && PATH/TO/dictionary.sh
```
### fish
Append this line to your *config.fish*:
```bash
if status is-login; 
else
	if status --is-interactive
		$HOME/doc/scripts/terminal-dictionary2/dictionary.sh
	end
end
```
