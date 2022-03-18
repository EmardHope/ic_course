import List "mo:base/List";
import Iter "mo:base/Iter";
import Principal "mo:base/Principal";
import Time "mo:base/Time";
//import Debug "mo:base/Debug";
import Int "mo:base/Int";


        
actor {
        stable var author:Text = "";

        public type Principal_Author = {
            principal: Principal;
            author: ?Text;
        };
        
        //public type Message = Text;
        public type Message = {
            author: Text;
            text: Text;
            time: Time.Time;
        };



        public type Microblog = actor{
            get_name:  shared query() -> async ?Text;
            follow: shared(Principal) -> async();
            follows: shared query() -> async[Principal];
            post: shared(Text) -> async();
            posts: shared query(Int) -> async [Message];
            timeline: shared(Int) -> async [Message];
        };

        //stable :升级后该变量不会重置
        stable var followed : List.List<Principal> = List.nil();//创建一个空List

        public shared func follow(id:Principal) : async(){
            followed := List.push(id,followed);
        };
        public shared func follows() : async [Principal]{
            List.toArray(followed)
        };

        public shared func follows_authors() : async [Principal_Author]{

            var principal_authors : List.List<Principal_Author> = List.nil();//创建一个空List
            for (id in Iter.fromList(followed)){
                let canister : Microblog = actor(Principal.toText(id));
                let author = await canister.get_name();
                let principal_author:Principal_Author = {principal=id; author = author };
                principal_authors := List.push(principal_author,principal_authors);
                    };              
            List.toArray(principal_authors)
        };


        public shared func get_author_name(id:Principal) : async ?Text{
                let canister : Microblog = actor(Principal.toText(id));
                let author = await canister.get_name();
        };
        
        public shared func get_author_posts(id:Principal) : async [Message]{
                let canister : Microblog = actor(Principal.toText(id));
                let messages = await canister.posts(0);
        };


         //?Text 是option类型
        public shared (msg) func set_name(name:Text) : async ?Text{
           assert (Principal.toText(msg.caller) == "3jf7v-4dwyz-mjuml-5xafc-ketqv-6t6vu-xa7ga-ogrop-manus-nc636-oqe"); 
            author := name;
                ?author          
        };
        public shared query func get_name() : async ?Text{
                    ?author
        };



        //POST
        stable var messages : List.List<Message> = List.nil();

        public shared (msg) func post(otp:Text , text:Text) : async (){
            //assert (Principal.toText(msg.caller) == "3jf7v-4dwyz-mjuml-5xafc-ketqv-6t6vu-xa7ga-ogrop-manus-nc636-oqe");
            assert (otp == "123456");
            let _myMsg : Message = {author = author; time = Time.now();  text = text};
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
                let msgs = await canister.posts(since);
                for(msg in Iter.fromArray(msgs)){
                    if(msg.time >= since){
                        all := List.push(msg,all)
                    };              
                }
            };

            List.toArray(all)
        };





};
