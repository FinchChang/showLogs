var $ApiURL = 'jsp/axiosDataGet.jsp';
var updateFlag = true;
Vue.prototype.$http = axios;
var dataLength = 0;
var dataCounter = 0;
var app = new Vue({
    el: '#app',
    data: {
        message: 'Hello Vue!',
        memo: '',
        time: 0
    },
    mounted: function counter() {
        interval = setInterval(() => {
            if (this.time == 0) {
                if(updateFlag){
                    this.get_store_info();
                }
            }
            if(this.time > 0){
                this.time = this.time - 1;
            }else{
                this.time = "waiting for data";
            }
        }, 1000)
    },
    methods: {
        get_store_info() {
            var self = this;
            let fmdata = 'dataLength='+dataLength+"&dataCounter="+dataCounter;
            this.$http.post($ApiURL,fmdata)
                .then((result) => {
                    console.log(result)
                    if(result.data.line != undefined){
                        dataCounter=result.data.line;
                    }
                    if(result.data.size != undefined){
                        dataLength=result.data.size;
                    }
                    if(result.status == 200){
                        this.message = result.data.content;
                    }else if(result.status == 206){
                        this.message += result.data.content;
                    }
                    if( result.data.size == 1){
                        this.memo = 'The data is loading, please wait..., the scroll will move to bottom when the data loading is completed.';
                        this.time = 0;
                    }else{
                        this.memo ='';
                        this.time = 5;
                        // this.scrollToEnd();
                    }
                })
                .catch(function(error) {
                    console.error(error);
                });
        },
        scrollToEnd: function() {
          window.scrollTo(0,document.querySelector(".logData").scrollHeight);
        },
    }
})
