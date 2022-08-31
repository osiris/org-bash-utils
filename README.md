# `org-bash-utils`

Utils _BASH_ scripts for `org-mode`

## overview

Repository of _BASH_ scripts for parse `org-mode` files.

## install

Clone the repository:

```bash
cd ~
mkdir -p git/osiux
cd git/osiux
git clone https://gitlab.com/osiux/org-bash-utils
```

Add to `~/.bashrc`:

```bash
if [[ -d "$HOME/git/osiux/org-bash-utils" ]]
then
    PATH="$HOME/git/osiux/org-bash-utils:$PATH"
    source $HOME/git/osiux/org-bash-utils/org-alias
    source $HOME/git/osiux/org-bash-utils/awk-alias
fi
```

## scripts

### `agenda-ascii`

Exports `.org` file to a calendar `.ics`, after convert to *Remind file*
`.rem` for finally draw a calendar ASCII:

```bash
agenda-ascii -f obu -r3 -c 80
```

```
CONVERT ICS TO REM ...
+----------+----------+----------+----------+----------+----------+----------+
|  Sunday  |  Monday  | Tuesday  |Wednesday | Thursday |  Friday  | Saturday |
+----------+----------+----------+----------+----------+----------+----------+
|9 Mar     |10 Mar    |11 Mar ***|12 Mar    |13 Mar    |14 Mar    |15 Mar    |
|          |          |          |          |          |          |          |
|          |NEXT      |          |          |          |          |          |
|          |Release   |          |          |          |          |          |
|          |0.1       |          |          |          |          |          |
|          |          |          |          |          |          |          |
|          |          |          |          |          |          |          |
+----------+----------+----------+----------+----------+----------+----------+
|16 Mar    |17 Mar    |18 Mar    |19 Mar    |20 Mar    |21 Mar    |22 Mar    |
|          |          |          |          |          |          |          |
|          |          |          |          |          |          |          |
|          |          |          |          |          |          |          |
|          |          |          |          |          |          |          |
|          |          |          |          |          |          |          |
|          |          |          |          |          |          |          |
+----------+----------+----------+----------+----------+----------+----------+
|23 Mar    |24 Mar    |25 Mar    |26 Mar    |27 Mar    |28 Mar    |29 Mar    |
|          |          |          |          |          |          |          |
|          |          |          |          |          |          |          |
|          |          |          |          |          |          |          |
|          |          |          |          |          |          |          |
|          |          |          |          |          |          |          |
|          |          |          |          |          |          |          |
+----------+----------+----------+----------+----------+----------+----------+
```

### `barra`

This script draw a simple bar chart. The input is a column number and a
column text like this:

```bash
org-status | head
```

```
3224 DONE
 377 NEXT
 132 CANCELLED
 117 TODO
  45 FIXED
   8 SOMEDAY
   8 DELEGATED
   6 TODAY
   5 WAITING
   5 POSTPONED
```

After you add a `pipe` and `barra` the result is:

```bash
org-status | head | barra
```

```
 82.10 %  82.10 %      3224 ███████████████████████████████████████ DONE
 91.70 %   9.60 %       377 █████ NEXT
 95.06 %   3.36 %       132 █ CANCELLED
 98.04 %   2.98 %       117 █ TODO
 99.19 %   1.15 %        45 ▌ FIXED
 99.39 %   0.20 %         8 ▌ SOMEDAY
 99.59 %   0.20 %         8 ▌ DELEGATED
 99.75 %   0.15 %         6 ▌ TODAY
 99.87 %   0.13 %         5 ▌ WAITING
100.00 %   0.13 %         5 ▌ POSTPONED
                       3927
```

If you configure `HISTTIMEFORMAT`\"%Y-%m-%d %H:%M \"= into `~/.bashrc`,
you can obtain a statistics of `bash` use:

```bash
history | grep 2014-04-11 | awk '{print $4}' | sort | uniq -c | sort -nr | head | barra
```

```
 23.57 %  23.57 %        37 ████████████ :q
 41.40 %  17.83 %        28 █████████ v
 54.78 %  13.38 %        21 ██████ cd
 66.24 %  11.46 %        18 █████ e
 75.16 %   8.92 %        14 ████ ls
 83.44 %   8.28 %        13 ████ ssh
 87.90 %   4.46 %         7 ██ ./ssltest.py
 92.36 %   4.46 %         7 ██ cdv
 96.18 %   3.82 %         6 ██ exit
100.00 %   3.82 %         6 ██ echo
                        157
```

### `org-clock`

Show a `CLOCK:` lines in all `.org` files for specific date:

```bash
org-clock 2014-02-28
```

```
13:09 13:40 almuerzo
12:26 13:05 gca
13:40 15:56 gca
13:40 15:56 gca
16:18 17:03 gca
20:28 20:38 gca
20:39 20:44 gca
21:08 21:38 gca
```

Default is current day:

```
org-clock
```

```
13:49 14:48 almuerzo
09:36 10:04 auditoria
12:55 13:05 auditoria
13:22 13:47 auditoria
10:12 10:29 gastos
10:30 10:40 gastos
10:50 12:20 marian
08:32 09:00 org
```

You can view a specific file:

```bash
org-clock 2014-02 almuerzo.org
```

```
13:50 14:28 2014-02-04
14:37 15:17 2014-02-06
14:14 15:20 2014-02-07
13:50 14:38 2014-02-10
13:55 14:48 2014-02-13
13:42 14:42 2014-02-14
11:50 14:50 2014-02-17
13:40 15:04 2014-02-18
13:37 13:48 2014-02-20
14:02 15:00 2014-02-20
14:00 14:49 2014-02-24
14:00 15:00 2014-02-25
13:09 13:40 2014-02-28
```

Adding `org-timeline` to result:

```bash
org-clock 2014-02 almuerzo.org | org-timeline
```

```bash
11:    12:    13:    14:    15:    16:
  ┊      ┊      ┊      ┊      ┊      ┊
  ┊□□□□▣▣┊□□□□□□┊□□□□□□┊□□□□□□┊□□□□□□┊ 2014-02-17 ===============>  180
  ┊□□□□□□┊□□□□□□┊□□□▣▣▣┊□□□□□□┊□□□□□□┊ 2014-02-18 ===============>   84
  ┊□□□□□□┊□□□□□□┊□▣▣▣□□┊□□□□□□┊□□□□□□┊ 2014-02-28 ===============>   31
  ┊□□□□□□┊□□□□□□┊□□□□▣▣┊□□□□□□┊□□□□□□┊ 2014-02-10 ===============>   48
  ┊□□□□□□┊□□□□□□┊□□□▣▣□┊▣▣▣▣▣▣┊□□□□□□┊ 2014-02-20 ===============>   69
  ┊□□□□□□┊□□□□□□┊□□□□□▨┊□□□□□□┊□□□□□□┊ 2014-02-13 ===============>   53
  ┊□□□□□□┊□□□□□□┊□□□□▣▣┊□□□□□□┊□□□□□□┊ 2014-02-04 ===============>   38
  ┊□□□□□□┊□□□□□□┊□□□▣▣▣┊□□□□□□┊□□□□□□┊ 2014-02-14 ===============>   60
  ┊□□□□□□┊□□□□□□┊□□□□□□┊▣▣▣▣▣□┊□□□□□□┊ 2014-02-24 ===============>   49
  ┊□□□□□□┊□□□□□□┊□□□□□□┊□□□▣▣▣┊□□□□□□┊ 2014-02-06 ===============>   40
  ┊□□□□□□┊□□□□□□┊□□□□□□┊▣▣▣▣▣▣┊□□□□□□┊ 2014-02-25 ===============>   60
  ┊□□□□□□┊□□□□□□┊□□□□□□┊□▨▣▣▣▣┊□□□□□□┊ 2014-02-07 ===============>   66
  ┊      ┊      ┊      ┊      ┊      ┊      TOTAL ===============>  778
```

### `org-count`

By default count tasks with `NEXT` keyword:

```bash
org-count | head
```

```
159 gca
 26 gcoop
 20 org
 20 cfp
 18 leonel
 16 osiux
 14 plan
 12 gastos
 11 frontweb
 10 osiris
```

Count specific `TODO KEYWORD`:

```bash
org-count TODO | head
```

```
32 org
13 caipiroska
11 auditoria
10 gcoop
10 bal
10 arbolito
 6 osiris
 6 frontweb
 4 SLconCFK
 4 osiux
```

### `org-status` {#org-status-1}

Show status of `TODO KEYWORDS` for `*.org` files:

```bash
org-status | head | barra
```

```
 81.94 %  81.94 %      3245 ███████████████████████████████████████ DONE
 91.72 %   9.77 %       387 █████ NEXT
 95.05 %   3.33 %       132 █ CANCELLED
 98.06 %   3.01 %       119 █ TODO
 99.19 %   1.14 %        45 ▌ FIXED
 99.39 %   0.20 %         8 ▌ SOMEDAY
 99.60 %   0.20 %         8 ▌ DELEGATED
 99.75 %   0.15 %         6 ▌ TODAY
 99.87 %   0.13 %         5 ▌ WAITING
100.00 %   0.13 %         5 ▌ POSTPONED
                       3960
```

Show status of `TODO KEYWORDS` for `obu.org` file:

```bash
org-status obu.org | barra
```

```
 55.56 %  55.56 %         5 ████████████████████████████ NEXT
 88.89 %  33.33 %         3 ████████████████ DONE
100.00 %  11.11 %         1 █████ TODO
                          9
```

### `org-timeline`

Draw a timeline for a serie of start and end date, group by third
column:

```bash
org-clock 2014-02-28 | org-timeline
```

```
12:    13:    14:    15:    16:    17:    18:    19:    20:    21:    22:
  ┊      ┊      ┊      ┊      ┊      ┊      ┊      ┊      ┊      ┊      ┊
  ┊□□□□□□┊□▣▣▣□□┊□□□□□□┊□□□□□□┊□□□□□□┊□□□□□□┊□□□□□□┊□□□□□□┊□□□□□□┊□□□□□□┊   almuerzo ===============>   31
  ┊□□▨▣▣▣┊□□□▣▣▣┊□□□□□□┊□□□□□□┊□▣▣▣▣▣┊□□□□□□┊□□□□□□┊□□□□□□┊□□▣▣▨□┊□▣▣▣□□┊        gca ===============>  401
  ┊      ┊      ┊      ┊      ┊      ┊      ┊      ┊      ┊      ┊      ┊      TOTAL ===============>  432
```

View detail of each line before group with `-d=2` parameter:

```
org-clock 2014-02-28 | org-timeline -v d=2
```

``` {.example}
12:    13:    14:    15:    16:    17:    18:    19:    20:    21:    22:
  ┊      ┊      ┊      ┊      ┊      ┊      ┊      ┊      ┊      ┊      ┊
  ┊□□□□□□┊□▣▣▣□□┊□□□□□□┊□□□□□□┊□□□□□□┊□□□□□□┊□□□□□□┊□□□□□□┊□□□□□□┊□□□□□□┊   almuerzo 13:09 - 13:40 =>   31
  ┊□□□□□□┊□▣▣▣□□┊□□□□□□┊□□□□□□┊□□□□□□┊□□□□□□┊□□□□□□┊□□□□□□┊□□□□□□┊□□□□□□┊   almuerzo ===============>   31
  ┊□□▨▣▣▣┊□□□□□□┊□□□□□□┊□□□□□□┊□□□□□□┊□□□□□□┊□□□□□□┊□□□□□□┊□□□□□□┊□□□□□□┊        gca 12:26 - 13:05 =>   39
  ┊□□□□□□┊□□□▣▣▣┊□□□□□□┊□□□□□□┊□□□□□□┊□□□□□□┊□□□□□□┊□□□□□□┊□□□□□□┊□□□□□□┊        gca 13:40 - 15:56 =>  136
  ┊□□□□□□┊□□□▣▣▣┊□□□□□□┊□□□□□□┊□□□□□□┊□□□□□□┊□□□□□□┊□□□□□□┊□□□□□□┊□□□□□□┊        gca 13:40 - 15:56 =>  136
  ┊□□□□□□┊□□□□□□┊□□□□□□┊□□□□□□┊□▣▣▣▣▣┊□□□□□□┊□□□□□□┊□□□□□□┊□□□□□□┊□□□□□□┊        gca 16:18 - 17:03 =>   45
  ┊□□□□□□┊□□□□□□┊□□□□□□┊□□□□□□┊□□□□□□┊□□□□□□┊□□□□□□┊□□□□□□┊□□▣▣□□┊□□□□□□┊        gca 20:28 - 20:38 =>   10
  ┊□□□□□□┊□□□□□□┊□□□□□□┊□□□□□□┊□□□□□□┊□□□□□□┊□□□□□□┊□□□□□□┊□□□▣▨□┊□□□□□□┊        gca 20:39 - 20:44 =>    5
  ┊□□□□□□┊□□□□□□┊□□□□□□┊□□□□□□┊□□□□□□┊□□□□□□┊□□□□□□┊□□□□□□┊□□□□□□┊□▣▣▣□□┊        gca 21:08 - 21:38 =>   30
  ┊□□▨▣▣▣┊□□□▣▣▣┊□□□□□□┊□□□□□□┊□▣▣▣▣▣┊□□□□□□┊□□□□□□┊□□□□□□┊□□▣▣▨□┊□▣▣▣□□┊        gca ===============>  401
  ┊      ┊      ┊      ┊      ┊      ┊      ┊      ┊      ┊      ┊      ┊      TOTAL ===============>  432
```

## License

_GNU General Public License, GPLv3._

## Author Information

This repo was created in 2013 by
 [Osiris Alejandro Gomez](https://osiux.com/), worker cooperative of
 [gcoop Cooperativa de Software Libre](https://www.gcoop.coop/).
