
let app = new Vue({
    el: '#app',

    data: {
        videoVisible: Config.useVideoBackground,
        videoLink: Config.videoLink,
        mp3Link: Config.mp3Link,
        musicVolume: 0.3,
        teamlist: Config.team,
        progress: 1,
        infotext: Config.infoText,
        color: Config.color,
        autoSongPlay: Config.autoSongPlay,
        copy: {
            left: {
                link: Config.copy.left.link, 
                text: Config.copy.left.text,
            }, // left copyfield
            middle: {
                link: Config.copy.middle.link, 
                text: Config.copy.middle.text,
            }, // middle copyfield
            right: {
                link: Config.copy.right.link, 
                text: Config.copy.right.text,
            }, // right copyfield    
        },
        cursor: {
            x: 0,
            y: 0,
        }
    },

    mounted() {
        window.addEventListener('message', function(e) {
            if(e.data.eventName === 'loadProgress') {
                document.getElementById("progress").style.width = (e.data.loadFraction * 100) + "%"
                document.getElementById('percent').innerHTML= parseInt(e.data.loadFraction * 100);
                //this.progress = e.data.loadFraction * 100;
            }
        });        

        window.addEventListener('keypress', (e) => {
            this.progress = this.progress + 1
            console.log(this.progress)
        })

        const cursor = document.getElementById('cursor');
        document.addEventListener('mousemove', (e) => {
            this.cursor.y = e.pageX
            this.cursor.x = e.pageY
        });

        let music = document.getElementById('music')
        if (music != null) {
            music.src = this.mp3Link;
            if (this.autoSongPlay) {
                console.log('lel')
                this.startMusic();
            } else {
                this.stopMusic();
            }
        }

        if (this.videoVisible) {
            let video = document.getElementById('myVideo')
            if (video != null) {
                video.src = this.videoLink;
            }
        }
    },

    methods: {
        startMusic() {
            document.getElementById('onmusic').classList.add('active-on');
            document.getElementById('offmusic').classList.remove('active-on');
            let music = document.getElementById('music');
            if (music != null) {
                music.play();
            }
        },

        stopMusic() {
            document.getElementById('onmusic').classList.remove('active-on');
            document.getElementById('offmusic').classList.add('active-on');
            let music = document.getElementById('music');
            if (music != null) {
                music.pause();
            }
        },

        startVideo() {
            document.getElementById('onvideo').classList.add('active-on');
            document.getElementById('offvideo').classList.remove('active-on');
            let video = document.getElementById('myVideo');
            if (video != null) {
                video.play();
            }
        },

        stopVideo() {
            document.getElementById('onvideo').classList.remove('active-on');
            document.getElementById('offvideo').classList.add('active-on');
            let video = document.getElementById('myVideo');
            if (video != null) {
                video.pause();
            }
        },

        copyLink(sort) {
            let colink 
            if (sort == 'left') {
                colink = this.data.copy.left.link
            } else if (sort == 'middle') {
                colink = this.data.copy.middle.link
            } else if (sort == 'right') {
                colink = this.data.copy.right.link
            }
            navigator.clipboard.writeText(colink);
        },

        updateMusicVolume() {
            let music = document.getElementById('music');
            music.volume = this.musicVolume;
        }
    }
});