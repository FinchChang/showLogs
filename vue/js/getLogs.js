var app = new Vue({
    el: '#app',
    data: {
        message: 'Hello Vue!',
        time: 5
    },
    mounted: function counter() {
        interval = setInterval(() => {
            if(this.time == 0) {
               this.time = 5;
            }
            this.time = this.time-1;
        }, 1000)
    }
})
