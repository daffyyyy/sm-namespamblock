## 🛡️ sm-namespamblock

<p  align="center">
<a  href="#description">Description 📄</a> | 
<a  href="#configuration">Configuration 🛠</a> | 
<a  href="#requirements">Requirements !</a> 
</p>

---

### Description
- Plugin bans players who spam with a nick change, most often used by cheaters to impersonate other players (avoid ban)
- Is possible to change your nickname X times in X time

### Configuration
<details>
<summary><b>Convars</b></summary>

```cfg

// How many changes is allowed (Safe value <= 10)
sm_namespamblock_allowed_times "10"

// The time in which you can make max changes, the number of changes reset after it
sm_namespamblock_allowed_times_seconds "35"

// Ban time length
sm_namespamblock_ban_time "10"
```
</details>

### Requirements
- SourceMod >= 1.10
- SourceBans++ (Optional)
