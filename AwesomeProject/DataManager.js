import React from 'react';
import firebase from 'firebase';

export default class DataManager {
    constructor() 
    {
        this.itemsRef = firebase.database().ref('/touristAttractions');
    }

    async removeFromFirebase(element) {
        this.itemsRef.child(element.id).remove();
    }

    async addToFirebase(attr) {
        this.itemsRef.push({
            city: attr.city,
            country: attr.country,
            name: attr.name,
            ratingAverage: attr.ratingAverage
          });
   
    }

    async updateUserRating(id, ratingAverage, userKey) {
        var updated =  false;                        
        firebase.database().ref('/users/'+userKey+'/ratings').once('value', (snap) => {
            snap.forEach((childSnap) => {
            if(childSnap.val().attrId == id) {
                firebase.database().ref('/users/'+userKey+'/ratings').child(childSnap.key).update({attrId: id, rating: ratingAverage});    
                updated = true;                       
            }
            });
            if(!updated) {
                firebase.database().ref('/users/'+userKey+'/ratings').push({
                    attrId: id,
                    rating: ratingAverage
                });
            }
        });
        
    }

    async updateAttraction(element) {
        this.itemsRef.child(element.id).update({city: element.city, country: element.country, name: element.name, ratingAverage: 0});                                            
    }
}