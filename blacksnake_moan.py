import bpy
from mathutils import Vector

class PlotTracts(bpy.types.Operator):
    bl_idname = "c2b.plot_tracts"
    bl_label = "Plot Tracts"
    bl_description = "Plot tracts from connectome source file in bezier curves"

    def execute(self, context: bpy.types.Context):
        # Reset group variable and open/parse curve data:
        groups = []
        curves = context.scene.get("curve_data")
        if not curves: raise ReferenceError("Please calculate tract data first")

        # Plot each dataset retrieved from the file data's regex results:
        for g in curves:
            g1 = int(g[1])

            # Plot curve:
            print(f'Now plotting a curve in tract ID ["{g1}"], using vector set:\n {g[0]}')
            context.view_layer.objects.active = self.makeCurve(g[0])
            current_curve = context.view_layer.objects.active

            # If the tract group has not been created yet, create it and add the curve:
            if g1 not in groups:
                print(f'Collection with tract ID ["{g1}"] does not exist. ')

                groups.append(int(g[1]))                
                print(f'Created group collection with ID ["{g1}"]')

                new_collection = bpy.data.collections.new(name=f"Tract {g1}")
                bpy.context.scene.collection.children.link(new_collection) 
                new_collection.objects.link(current_curve)
                bpy.context.collection.objects.unlink(current_curve) # remove from default collection
                print(f"Added {current_curve} to {new_collection}\n")

            # If the tract group already is created, add the curve:
            else:
                new_collection.objects.link(current_curve)
                bpy.context.collection.objects.unlink(current_curve) # remove from default collection
                print(f"Added {current_curve} to {new_collection} \n")

        print("Connectome plotting completed!")

        return {'FINISHED'}

    def makeCurve(self, vertices: str):
        # Create spline data
        curveData = bpy.data.curves.new('myCurve', type='CURVE')
        curveData.dimensions = '3D'
        curveObj = curveData.splines.new('NURBS')
        
        # Get coordinates to plot
        coords3d = self.getTractCoords(vertices)
        #print(coords3d)
        
        # Plot vectors on curve
        curveObj.points.add(len(coords3d)-1)        # subtract one from length because one point already exists (add needs the number of _new_ points)
        for i, coords in enumerate(coords3d):
            x,y,z = coords
            curveObj.points[i].co = (x, y, z, 1)

        # Create curve object from spline
        curve = bpy.data.objects.new('Tract Curve', curveData)

        # Temporarily add curve to default collection, so it is the active object
        bpy.context.collection.objects.link(curve)
        
        return curve

    def getTractCoords(self, tract: str):
        tract_vertices = list()
        vertex = list()

        for i, coord in enumerate(tract.split(' ')):
            try:
                vertex.append(float(coord))
            except ValueError:
                continue

            if (i+1) % 3 == 0:
                tract_vertices.append( Vector(vertex) )
                vertex.clear()

        return tract_vertices
