import axios from 'axios';

async function testCreateProduct() {
    try {
        // 1. Login as Admin to get Token
        const loginRes = await axios.post('http://localhost:5000/api/v1/users/admin/login', {
            email: 'admin@proshop.com',
            password: 'Admin@123'
        });
        const token = loginRes.data.token;
        console.log('Login successful. Token obtained.');

        const catRes = await axios.get('http://localhost:5000/api/v1/categories', {
            headers: { Authorization: `Bearer ${token}` }
        });
        let categories = catRes.data.data.categories;
        let categoryId;

        if (categories.length === 0) {
            console.log('No categories found. Creating a test category...');
            const newCatRes = await axios.post('http://localhost:5000/api/v1/categories', {
                name: 'Electronics',
                description: 'Test Electronics Category'
            }, {
                headers: { Authorization: `Bearer ${token}` }
            });
            categoryId = newCatRes.data.data.category._id;
            console.log('Created Test Category:', categoryId);
        } else {
            categoryId = categories[0]._id;
        }

        console.log(`Using Category ID: ${categoryId}`);

        // 3. Create Product
        const productData = {
            name: 'Test Product ' + Date.now(),
            description: 'This is a test product created via script.',
            price: 99.99,
            stock: 100,
            category: categoryId,
            images: ['https://example.com/image1.jpg'],
            isActive: true
        };

        const createRes = await axios.post('http://localhost:5000/api/v1/products', productData, {
            headers: { Authorization: `Bearer ${token}` }
        });

        console.log('Product creation response status:', createRes.status);
        console.log('Product created:', createRes.data.data.product.name);

    } catch (error) {
        console.error('Error:', error.response ? error.response.data : error.message);
    }
}

testCreateProduct();
