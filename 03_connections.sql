-- news.u_id -> reg_user.user_id, news.motorsport_category -> motorsport.motorsport_id
ALTER TABLE news
      ADD CONSTRAINT news_reg_user_fk FOREIGN KEY (u_id) REFERENCES reg_user(user_id)
      ADD CONSTRAINT news_motorsport_fk FOREIGN KEY (motorsport_category) REFERENCES motorsport(motorsport_id);
      
-- favored_motorsport.u_id -> reg_user.user_id, favored_motorsport.motorsport_id -> motorsport.motorsport_id
ALTER TABLE favored_motorsport
      ADD CONSTRAINT favored_motorsport_reg_user_fk FOREIGN KEY (u_id) REFERENCES reg_user(user_id)
      ADD CONSTRAINT favored_motorsp_motorsport_fk FOREIGN KEY (motorsport_id) REFERENCES motorsport(motorsport_id);            

-- chatroom.motorsport_category -> motorsport.motorsport_id
ALTER TABLE chatroom
      ADD CONSTRAINT chatroom_motorsport_FK FOREIGN KEY (motorsport_category) REFERENCES motorsport(motorsport_id);
    
-- race.motorsport_id -> motorsport.motorsport_id, race.track_id -> track.track_id
ALTER TABLE race
      ADD CONSTRAINT race_motorsport_fk FOREIGN KEY (motorsport_id) REFERENCES motorsport(motorsport_id)
      ADD CONSTRAINT race_track_fk FOREIGN KEY (track_id) REFERENCES track(track_id);
      
-- news_comment.user_id -> reg_user.user_id, news_comment.news_id -> news.news_id
ALTER TABLE news_comment
      ADD CONSTRAINT news_comment_reg_user_fk FOREIGN KEY (u_id) REFERENCES reg_user(user_id)
      ADD CONSTRAINT news_comment_news_fk FOREIGN KEY (news_id) REFERENCES news(news_id);
      
--chatroom_messages.user_id -> reg_user.user_id, chatroom_messages.chatroom_id -> 
ALTER TABLE chatroom_messages
      ADD CONSTRAINT reg_user_chatroom_msg_fk FOREIGN KEY (user_id) REFERENCES reg_user(user_id)
      ADD CONSTRAINT chatroom_chatroom_msg_fk FOREIGN KEY (chatroom_id) REFERENCES chatroom(chatroom_id);
