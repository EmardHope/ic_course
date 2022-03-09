import List "mo:base/List";
import Iter "mo:base/Iter";
import Principal "mo:base/Principal";
import Time "mo:base/Time";
//import Debug "mo:base/Debug";
import Int "mo:base/Int";

actor {
        //public type Message = Text;
        public type Message = {
            time:Int;
            text:Text;
        };

        public type Microblog = actor{
            follow: shared(Principal) -> async();
            follows: shared query() -> async[Principal];
            post: shared(Text) -> async();
            posts: shared query() -> async [Message];
            timeline: shared() -> async [Message];
        };

        //stable :升级后该变量不会重置
        stable var followed : List.List<Principal> = List.nil();//创建一个空List

        public shared func follow(id:Principal) : async(){
            followed := List.push(id,followed);
        };
        public shared func follows() : async [Principal]{
            List.toArray(followed)
        };

        //POST
        stable var messages : List.List<Message> = List.nil();

        public shared (msg) func post(text:Text) : async (){
            assert (Principal.toText(msg.caller) == "3jf7v-4dwyz-mjuml-5xafc-ketqv-6t6vu-xa7ga-ogrop-manus-nc636-oqe");
            let _myMsg : Message = {time = Time.now();  text = text};
            messages := List.push(_myMsg,messages)
        };

        public shared func posts(since: Time.Time) : async [Message]{
             var all : List.List<Message> = List.nil();
            for(msg in Iter.fromList(messages)){
                //Debug.print(Int.toText(msg.time));
                if(msg.time >= since){
                    all := List.push(msg,all);
                };              
            };
            List.toArray(all)
        };
        public shared func timeline(since: Time.Time) : async [Message]{
            var all : List.List<Message> = List.nil(); 

            for (id in Iter.fromList(followed)){
                let canister : Microblog = actor(Principal.toText(id));
                let msgs = await canister.posts();
                for(msg in Iter.fromArray(msgs)){
                    if(msg.time >= since){
                        all := List.push(msg,all)
                    };              
                }
            };

            List.toArray(all)
        };



};
