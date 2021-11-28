describe('MyMovies Page', () => {
    
    it('Should be able to view the movie movie list', () => {
        cy.intercept('GET', '/api/whoami', { fixture: "whoami.json" });
        cy.intercept('GET', '/api/mymovies', { fixture: "mymovies.json" });

        cy.visit('/mymovies')
        
        cy.get('[data-cy="movie-list"] li').should('have.length', 4)
        cy.contains('li div.title', 'The Muppet Movie').should('be.visible')
    })

})