/**
 * @pageLayouts unsplash
 */
component {

	property name="cover_image" relationship="many-to-one" relatedTo="asset" allowedTypes="image";

}