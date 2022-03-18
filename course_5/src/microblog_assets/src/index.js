import { microblog } from "../../declarations/microblog";

async function post(){
  console.log("post!");
  let post_button = document.getElementById("post");
  post_button.disabled = true;
  let textarea = document.getElementById("message");
  let text = textarea.value;

  let otparea = document.getElementById("otp");
  let otp = otparea.value;


  console.log(otp,text);
  
  try {
    await microblog.post(otp,text);
    textarea.value = "";//清空旧内容
    //otparea.value = "";
  } 
  catch (error) {
    console.log(error);
    document.getElementById("error").innerText = "Post Failed!";
  }

  post_button.disabled = false;
}


var num_posts = 0;//优化setInterval显示
async function load_posts(){
  console.log("load_posts!");
  let posts_section = document.getElementById("posts");
  let posts = await microblog.posts(0);//带上时间戳，默认0

  //优化setInterval显示
  if (num_posts == posts.length) return;
  posts_section.replaceChildren([]);
  num_posts == posts.length;

  for (var i=0; i < posts.length; i++){
    let post = document.createElement("p");
    console.log("posts[i].author",posts[i].author);
    console.log("posts[i].time",posts[i].time);
    console.log("posts[i].text",posts[i].text);

    post.innerText = posts[i].author + "\n" + new Date(parseInt(String(posts[i].time))/1000000) + "\n" + posts[i].text + "\n" + "------------------\n" ;
    posts_section.appendChild(post);
  }
}




async function ck(id){
  document.getElementById("loading").innerText = "正在加载用户消息列表...请等待1秒左右";
  let text = "";
  let posts = await microblog.get_author_posts(id);
  for (var i=0; i < posts.length; i++){
    text = text + "作者:" + posts[i].author + "\n" + "时间:" +  new Date(parseInt(String(posts[i].time))/1000000) + "\n" + "内容:" +  posts[i].text + "\n*****\n"
  }
    console.log(text)
    document.getElementById("loading").innerText = "加载完毕，点击用户昵称获取其消息列表";
  alert(text)
} 



var num_follows = 0;//优化setInterval显示
async function load_follows(){
  console.log("load_follows!");
  document.getElementById("loading").innerText = "正在加载关注列表...请稍候";
  let follows_section = document.getElementById("follows");
  let follows = await microblog.follows_authors();
  console.log(follows[0].author);
  console.log(follows[0].principal.toString());

  //优化setInterval显示
  if (num_follows == follows.length) return;
  follows_section.replaceChildren([]);
  num_follows == follows.length;

  for (var i=0; i < follows.length; i++){
    let follow = document.createElement("p");
    follow.id = i;
    follow.onclick = function() { ck(follows[follow.id].principal); }
    
    follow.innerText = follows[i].author +"  ("+ follows[i].principal.toString() + ")" + "\n" ;
    follows_section.appendChild(follow);
  }
  document.getElementById("loading").innerText = "加载完毕，点击用户昵称获取其消息列表";
}



var num_timeline = 0;//优化setInterval显示
async function load_timeline(){
  let timeline_section = document.getElementById("timeline");
  let timeline = await microblog.timeline(0);//带上时间戳，默认0
  console.log('timeline:',timeline);

  //优化setInterval显示
  if (num_timeline == timeline.length) return;
  timeline_section.replaceChildren([]);
  num_timeline == timeline.length;

  for (var i=0; i < timeline.length; i++){
    let timeline_ = document.createElement("p");
    console.log("timeline",i,":",timeline[i]);

    timeline_.innerText = "作者:" + timeline[i].author + "\n" + "时间:" + new Date(parseInt(String(timeline[i].time))/1000000) + "\n" + "内容:" +  timeline[i].text + "\n" + "------------------\n";
    timeline_section.appendChild(timeline_);
  }
}



function load(){
  console.log("load!");
    let post_button = document.getElementById("post");
    post_button.onclick = post;
    
    load_follows();
    load_timeline();
    //load_posts();
    setInterval(load_timeline,10000);
  
    

  }



window.onload=function(){
  console.log("onload");
  load()

}