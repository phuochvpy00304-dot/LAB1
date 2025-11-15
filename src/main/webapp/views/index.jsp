<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!doctype html>
<html lang="vi">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width,initial-scale=1" />
  <title>Web Nhạc - LAB1</title>
  <style>
    /* simple, responsive layout */
    :root { --bg:#0f1724; --card:#0b1220; --accent:#1db954; --muted:#9aa4b2; --text:#e6eef6; }
    body{margin:0;font-family:Inter,Segoe UI,Roboto,Helvetica,Arial;background:linear-gradient(180deg,#071025 0%, #071a2b 100%);color:var(--text);display:flex;min-height:100vh;align-items:center;justify-content:center;padding:20px;}
    .player{width:100%;max-width:900px;background:linear-gradient(180deg,rgba(255,255,255,0.02),rgba(0,0,0,0.02));border-radius:14px;padding:20px;box-shadow:0 8px 30px rgba(2,6,23,0.6);display:grid;grid-template-columns:240px 1fr;gap:18px;align-items:center;}
    .cover{width:220px;height:220px;background:#111;border-radius:10px;display:flex;align-items:center;justify-content:center;overflow:hidden}
    .cover img{width:100%;height:100%;object-fit:cover}
    .meta h1{margin:0;font-size:20px}
    .meta p{color:var(--muted);margin:6px 0 14px}
    .controls{display:flex;align-items:center;gap:12px}
    .btn{background:transparent;border:0;color:var(--text);cursor:pointer;padding:10px;border-radius:8px;font-size:18px}
    .btn.big{font-size:20px;padding:12px}
    .btn:hover{background:rgba(255,255,255,0.03)}
    .progress{width:100%;height:8px;background:rgba(255,255,255,0.06);border-radius:6px;overflow:hidden;cursor:pointer}
    .progress > i{display:block;height:100%;width:0%;background:linear-gradient(90deg,var(--accent),#63d37a);border-radius:6px}
    .time{display:flex;justify-content:space-between;color:var(--muted);font-size:13px;margin-top:6px}
    .right{padding:6px 0}
    .playlist{max-height:260px;overflow:auto;margin-top:10px;border-top:1px solid rgba(255,255,255,0.03);padding-top:10px}
    .track{display:flex;gap:10px;align-items:center;padding:8px;border-radius:8px;cursor:pointer}
    .track:hover{background:rgba(255,255,255,0.02)}
    .track.active{background:rgba(29,185,84,0.08)}
    .track .tmeta{flex:1}
    .track .tmeta .title{font-size:14px}
    .track .tmeta .artist{font-size:12px;color:var(--muted)}
    .volume{display:flex;align-items:center;gap:8px;margin-left:8px}
    input[type="range"]{appearance:none;height:6px;background:rgba(255,255,255,0.06);border-radius:6px}
    input[type="range"]::-webkit-slider-thumb{appearance:none;width:14px;height:14px;border-radius:50%;background:var(--accent);border:2px solid #fff}
    footer{grid-column:1/-1;text-align:center;color:var(--muted);font-size:12px;margin-top:14px}
    @media(max-width:720px){.player{grid-template-columns:1fr;}}
  </style>
</head>
<body>
  <div class="player" role="application" aria-label="Web Music Player">
    <div>
      <div class="cover">
        <img id="coverImg" src="assets/cover-default.jpg" alt="Album cover" />
      </div>
      <div style="margin-top:12px;display:flex;justify-content:space-between;align-items:center;">
        <div style="color:var(--muted);font-size:13px">Playlist</div>
        <div style="color:var(--muted);font-size:13px" id="currentIndex">0 / 0</div>
      </div>
      <div class="playlist" id="playlist"></div>
    </div>

    <div class="right">
      <div class="meta">
        <h1 id="title">Hello World!</h1>
        <p id="artist">Một trang web nhạc đơn giản</p>
      </div>

      <div style="margin-top:14px" class="controls">
        <button id="prev" class="btn" title="Previous">⏮</button>
        <button id="play" class="btn big" title="Play/Pause">▶️</button>
        <button id="next" class="btn" title="Next">⏭</button>

        <div style="flex:1"></div>

        <button id="shuffleBtn" class="btn" title="Shuffle">🔀</button>
        <button id="repeatBtn" class="btn" title="Repeat">🔁</button>

        <div class="volume">
          <span style="font-size:14px;color:var(--muted)">🔊</span>
          <input id="volume" type="range" min="0" max="1" step="0.01" value="0.8" style="width:90px">
        </div>
      </div>

      <div style="margin-top:14px">
        <div class="progress" id="progress">
          <i id="progressBar"></i>
        </div>
        <div class="time">
          <span id="currentTime">00:00</span>
          <span id="duration">00:00</span>
        </div>
      </div>

      <!-- Hidden audio element -->
      <audio id="audio"></audio>

      <footer>Made with ❤ — LAB1</footer>
    </div>
  </div>

  <script>
    // === playlist configuration ===
    const tracks = [
      {
        title: "Bài hát mẫu 1",
        artist: "Ca sĩ A",
        src: "media/song1.mp3",
        cover: "assets/cover1.jpg"
      },
      {
        title: "Bài hát mẫu 2",
        artist: "Ca sĩ B",
        src: "media/song2.mp3",
        cover: "assets/cover2.jpg"
      },
      {
        title: "Bài hát mẫu 3",
        artist: "Ca sĩ C",
        src: "media/song3.mp3",
        cover: "assets/cover3.jpg"
      }
    ];

    // === elements ===
    const audio = document.getElementById('audio');
    const playBtn = document.getElementById('play');
    const prevBtn = document.getElementById('prev');
    const nextBtn = document.getElementById('next');
    const titleEl = document.getElementById('title');
    const artistEl = document.getElementById('artist');
    const coverImg = document.getElementById('coverImg');
    const progress = document.getElementById('progress');
    const progressBar = document.getElementById('progressBar');
    const currentTimeEl = document.getElementById('currentTime');
    const durationEl = document.getElementById('duration');
    const playlistEl = document.getElementById('playlist');
    const volumeEl = document.getElementById('volume');
    const shuffleBtn = document.getElementById('shuffleBtn');
    const repeatBtn = document.getElementById('repeatBtn');
    const currentIndexEl = document.getElementById('currentIndex');

    let currentIndex = 0;
    let isPlaying = false;
    let isShuffle = false;
    let isRepeat = false;

    // build playlist UI
    function renderPlaylist(){
      playlistEl.innerHTML = '';
      tracks.forEach((t, i) => {
        const tr = document.createElement('div');
        tr.className = 'track' + (i===currentIndex ? ' active' : '');
        tr.innerHTML = `<div style="width:46px;height:46px;flex-shrink:0;border-radius:6px;overflow:hidden">
                          <img src="${t.cover || 'assets/cover-default.jpg'}" alt="" style="width:100%;height:100%;object-fit:cover">
                        </div>
                        <div class="tmeta">
                          <div class="title">${t.title}</div>
                          <div class="artist">${t.artist}</div>
                        </div>
                        <div style="color:var(--muted);font-size:13px;padding-right:6px">▶</div>`;
        tr.addEventListener('click', ()=>{ loadTrack(i); playTrack(); });
        playlistEl.appendChild(tr);
      });
      currentIndexEl.textContent = `${currentIndex+1} / ${tracks.length}`;
    }

    // load a track by index
    function loadTrack(i){
      if(i < 0) i = tracks.length - 1;
      if(i >= tracks.length) i = 0;
      currentIndex = i;
      const t = tracks[i];
      audio.src = t.src;
      titleEl.textContent = t.title;
      artistEl.textContent = t.artist;
      coverImg.src = t.cover || 'assets/cover-default.jpg';
      updateActiveTrack();
      // reset times
      currentTimeEl.textContent = '00:00';
      durationEl.textContent = '00:00';
    }

    function updateActiveTrack(){
      Array.from(playlistEl.children).forEach((el, idx) => {
        el.classList.toggle('active', idx===currentIndex);
      });
      currentIndexEl.textContent = `${currentIndex+1} / ${tracks.length}`;
    }

    function playTrack(){
      audio.play().then(()=> {
        isPlaying = true;
        playBtn.textContent = '⏸';
      }).catch(err=>{
        console.warn('Playback blocked or error', err);
      });
    }

    function pauseTrack(){
      audio.pause();
      isPlaying = false;
      playBtn.textContent = '▶️';
    }

    playBtn.addEventListener('click', ()=>{
      if(!audio.src) loadTrack(currentIndex);
      if(isPlaying) pauseTrack(); else playTrack();
    });

    prevBtn.addEventListener('click', ()=>{
      if(isShuffle){
        playRandom();
      } else {
        loadTrack(currentIndex - 1);
        playTrack();
      }
    });

    nextBtn.addEventListener('click', ()=>{
      if(isShuffle){
        playRandom();
      } else {
        loadTrack(currentIndex + 1);
        playTrack();
      }
    });

    // shuffle & repeat toggles
    shuffleBtn.addEventListener('click', ()=>{
      isShuffle = !isShuffle;
      shuffleBtn.style.opacity = isShuffle ? '1' : '0.6';
    });
    repeatBtn.addEventListener('click', ()=>{
      isRepeat = !isRepeat;
      repeatBtn.style.opacity = isRepeat ? '1' : '0.6';
      audio.loop = isRepeat;
    });

    function playRandom(){
      let next = Math.floor(Math.random()*tracks.length);
      if(tracks.length>1 && next === currentIndex){
        next = (next+1) % tracks.length;
      }
      loadTrack(next); playTrack();
    }

    // progress updates
    audio.addEventListener('timeupdate', ()=>{
      if(audio.duration){
        const percent = (audio.currentTime / audio.duration) * 100;
        progressBar.style.width = percent + '%';
        currentTimeEl.textContent = formatTime(audio.currentTime);
        durationEl.textContent = isFinite(audio.duration) ? formatTime(audio.duration) : '00:00';
      }
    });

    progress.addEventListener('click', (e)=>{
      const rect = progress.getBoundingClientRect();
      const x = e.clientX - rect.left;
      const percent = x / rect.width;
      if(audio.duration) audio.currentTime = percent * audio.duration;
    });

    audio.addEventListener('ended', ()=>{
      if(isRepeat) { audio.currentTime = 0; playTrack(); }
      else { nextBtn.click(); }
    });

    // volume
    volumeEl.addEventListener('input', ()=> audio.volume = volumeEl.value);

    // helpers
    function formatTime(sec){
      sec = Math.floor(sec || 0);
      const m = Math.floor(sec/60).toString().padStart(2,'0');
      const s = (sec%60).toString().padStart(2,'0');
      return `${m}:${s}`;
    }

    // init
    renderPlaylist();
    loadTrack(0);
    audio.volume = parseFloat(volumeEl.value);

    // keyboard: space to play/pause
    document.addEventListener('keydown', (e)=>{
      if(e.code === 'Space' && ! (e.target && /input|textarea/i.test(e.target.tagName)) ){
        e.preventDefault();
        playBtn.click();
      }
    });
  </script>
</body>
</html>
