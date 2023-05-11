/**
 * SurveyFeedback.js
 */

import { LightningElement, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getQuestions from '@salesforce/apex/SurveyController.getQuestions';
import saveSurvey from '@salesforce/apex/SurveyController.saveSurvey';

export default class SurveyFeedback extends LightningElement {
    @track surveyQuestions;
    @track surveyResponses = [];

    connectedCallback(){
        this.getSurveyQuestions();
    }

    getSurveyQuestions(){
        getQuestions()
        .then(result => {
            this.surveyQuestions = result;
        })
        .catch(error => {
            // eslint-disable-next-line no-console
            console.error('Error in getting survey questions: ', error);
        });
    }

    handleAnswerSelection(event){
        this.surveyResponses = event.detail;
    }

    handleSubmit(){
        saveSurvey({
            surveyResponses: this.surveyResponses
        })
        .then(result => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Survey responses have been saved',
                    variant: 'success'
                }) 
            );
        })
        .catch(error => {
            // eslint-disable-next-line no-console
            console.error('Error in saving survey responses: ', error);
        });
    }
}