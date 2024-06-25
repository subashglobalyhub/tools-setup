import { Knex } from "knex";

export async function up(knex: Knex): Promise<void> {
    const tableExists = await knex.schema.hasTable('todolist');
    
    if (!tableExists) {
        return knex.schema.createTable('todolist', (table) => {
	    table.increments('id').primary();
	    table.string('title').notNullable();
            table.string('description').notNullable();
            table.boolean('completed').notNullable().defaultTo(false);
        });
    } else {
        console.log('Table "todolist" already exists. Skipping creation.');
    }
}

export async function down(knex: Knex): Promise<void> {
}

