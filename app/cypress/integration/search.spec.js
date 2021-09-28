describe('Search Page', () => {

    it('Should load the page', () => {
        cy.visit('/search')
    })

    it('Should be able to search for a movie', () => {
        cy.visit('/search')
        cy.get('#search').type('muppet')
        cy.get('button.search').click()
        cy.contains('li div.title', 'The Muppet Movie').should('be.visible')
    })

})