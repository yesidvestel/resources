const s_click = new Audio('sounds/click.mp3?2');
const s_over = new Audio('sounds/over.wav?2');
const s_transition = new Audio('sounds/transition.ogg');
const s_talkoff = new Audio('sounds/walkieoff.mp3');
const s_talkon = new Audio('sounds/walkieon.mp3');

s_click.volume = 0.1;
s_over.volume = 0.1;
s_transition.volume = 0.2;
s_talkoff.volume = 0.3;
s_talkon.volume = 0.5;

function PlayClick() {
    s_click.currentTime = 0;
    s_click.play();
}

function PlayOver() {
    s_over.currentTime = 0;
    s_over.play();
}

function PlayTransition() {
    s_transition.currentTime = 0;
    s_transition.play();
}

function PlayTalkOff() {
    s_talkoff.currentTime = 0;
    s_talkoff.play();
}

function PlayTalkOn() {
    s_talkon.currentTime = 0;
    s_talkon.play();
}